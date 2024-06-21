import mudConfig from "contracts/mud.config";
import { setup as mudSetup } from "./mud/setup";

export async function setupDevTools(
  config: typeof mudConfig,
  setup: Awaited<ReturnType<typeof mudSetup>>
) {
  // https://vitejs.dev/guide/env-and-mode.html
  if (import.meta.env.DEV) {
    const { mount: mountDevTools } = await import("@latticexyz/dev-tools");
    mountDevTools({
      config: config,
      publicClient: setup.network.publicClient,
      // TODO fix the type annotation
      walletClient: setup.network.walletClient,
      latestBlock$: setup.network.latestBlock$,
      storedBlockLogs$: setup.network.storedBlockLogs$,
      worldAddress: setup.network.worldContract.address,
      worldAbi: setup.network.worldContract.abi,
      write$: setup.network.write$,
      useStore: setup.network.useStore,
    });
  }
}
