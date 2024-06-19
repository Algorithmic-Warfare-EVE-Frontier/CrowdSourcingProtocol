/*
 * Create the system calls that the client can use to ask
 * for changes in the World state (using the System contracts).
 */

import { SetupNetworkResult } from "./setupNetwork";
import { IVectorForm } from "../components/csp/forms/VectorForm";
import { IPotentialForm } from "../components/csp/forms/PotentialForm";
import { hexToBytes } from "viem";

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls(
  /*
   * The parameter list informs TypeScript that:
   *
   * - The first parameter is expected to be a
   *   SetupNetworkResult, as defined in setupNetwork.ts
   *
   *   Out of this parameter, we only care about two fields:
   *   - worldContract (which comes from getContract, see
   *     https://github.com/latticexyz/mud/blob/main/templates/react/packages/client/src/mud/setupNetwork.ts#L63-L69).
   *
   *   - waitForTransaction (which comes from syncToRecs, see
   *     https://github.com/latticexyz/mud/blob/main/templates/react/packages/client/src/mud/setupNetwork.ts#L77-L83).
   *
   * - From the second parameter, which is a ClientComponent,
   *   we only care about Counter. This parameter comes to use
   *   through createClientComponents.ts, but it originates in
   *   syncToRecs
   *   (https://github.com/latticexyz/mud/blob/main/templates/react/packages/client/src/mud/setupNetwork.ts#L77-L83).
   */
  { worldContract, waitForTransaction }: SetupNetworkResult
) {
  const initiateVector = async (data: IVectorForm) => {
    const { capacity, lifetime, insight } = data;
    const tx = await worldContract.write.csp__initiateVector([
      capacity,
      lifetime + BigInt(Date.now()),
      insight,
    ]);
    await waitForTransaction(tx);
  };

  const createDelta = async (data: IPotentialForm) => {
    const { vectorId, strength } = data;
    const tx = await worldContract.write.csp__createDelta([vectorId, strength]);
    await waitForTransaction(tx);
  };
  return {
    initiateVector,
    createDelta,
  };
}
