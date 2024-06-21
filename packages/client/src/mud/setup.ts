/*
 * This file sets up all the definitions required for a MUD client.
 */

import { createWalletClient } from "viem";
import { createSystemCalls } from "./createSystemCalls";
import { setupNetwork } from "./setupNetwork";

export type SetupResult = Awaited<ReturnType<typeof setup>>;

export async function setup(
  walletClient?: ReturnType<typeof createWalletClient>
) {
  const network = await setupNetwork(walletClient);
  const systemCalls = createSystemCalls(network);

  return {
    network,
    systemCalls,
  };
}
