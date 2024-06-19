import ReactDOM from "react-dom/client";
import { RouterProvider } from "react-router-dom";
import { ThemeProvider } from "@mui/material";
import { setup } from "./mud/setup";
import { MUDProvider } from "./MUDContext";
import mudConfig from "contracts/mud.config";
import {
  SmartObjectProvider,
  FeedbackProvider,
  WalletProvider,
  WorldProvider,
} from "@eveworld/contexts";
import { darkTheme } from "./theme";
import { router } from "./router";

const rootElement = document.getElementById("root");
if (!rootElement) throw new Error("React root not found");
const root = ReactDOM.createRoot(rootElement);

// TODO: figure out if we actually want this to be async or if we should render something else in the meantime
setup().then(async (result) => {
  root.render(
    <WalletProvider>
      <WorldProvider>
        <ThemeProvider theme={darkTheme}>
          <SmartObjectProvider>
            <FeedbackProvider>
              <MUDProvider value={result}>
                <RouterProvider router={router} />
              </MUDProvider>
            </FeedbackProvider>
          </SmartObjectProvider>
        </ThemeProvider>
      </WorldProvider>
    </WalletProvider>
  );

  // https://vitejs.dev/guide/env-and-mode.html
  if (import.meta.env.DEV) {
    const { mount: mountDevTools } = await import("@latticexyz/dev-tools");
    mountDevTools({
      config: mudConfig,
      publicClient: result.network.publicClient,
      walletClient: result.network.walletClient,
      latestBlock$: result.network.latestBlock$,
      storedBlockLogs$: result.network.storedBlockLogs$,
      worldAddress: result.network.worldContract.address,
      worldAbi: result.network.worldContract.abi,
      write$: result.network.write$,
      useStore: result.network.useStore,
    });
  }
});
