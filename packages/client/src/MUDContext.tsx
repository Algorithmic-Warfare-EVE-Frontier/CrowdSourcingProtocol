import {
  createContext,
  ReactNode,
  useContext,
  useEffect,
  useState,
} from "react";
import { setup, SetupResult } from "./mud/setup";
import { WalletContext } from "@eveworld/contexts";
import { setupDevTools } from "./devTools";
import mudConfig from "contracts/mud.config";
import {
  ClientConfig,
  createWalletClient,
  fallback,
  http,
  webSocket,
} from "viem";
import { getNetworkConfig } from "./mud/getNetworkConfig";
import { transportObserver } from "@latticexyz/common";

const MUDContext = createContext<SetupResult | null>(null);

type Props = {
  children: ReactNode;
  value: SetupResult;
};

export const MUDProvider = ({ children, value }: Props) => {
  const currentValue = useContext(MUDContext);
  const { walletClient } = useContext(WalletContext);
  const [MUDSetup, setMUDSetup] = useState(value);

  useEffect(() => {
    if (walletClient) {
      getNetworkConfig().then((networkConfig) => {
        // - Reuse the default client options from `setupNetwork.ts`.
        const clientOptions = {
          chain: networkConfig.chain,
          transport: transportObserver(fallback([webSocket(), http()])),
          pollingInterval: 1000,
        } as const satisfies ClientConfig;

        // - Create a new client using the account from the logged wallet and the options from the default setup.
        const burnerWalletClient = createWalletClient({
          ...clientOptions,
          // TODO fix this type issue.
          account: walletClient.account,
        });

        // - Re-execute the setup with the changed wallet client.
        setup(burnerWalletClient).then((setup) => {
          // - Capture the new setup to pass down as context
          setMUDSetup(setup);

          // - Launch the dev tools using the metamask account.
          setupDevTools(mudConfig, setup);
        });
      });
    }
  }, [walletClient]);

  if (currentValue) throw new Error("MUDProvider can only be used once");
  return <MUDContext.Provider value={MUDSetup}>{children}</MUDContext.Provider>;
};

export const useMUD = () => {
  const value = useContext(MUDContext);
  if (!value) throw new Error("Must be used within a MUDProvider");
  return value;
};
