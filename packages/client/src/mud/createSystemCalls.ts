/*
 * Create the system calls that the client can use to ask
 * for changes in the World state (using the System contracts).
 */

import { SetupNetworkResult } from "./setupNetwork";
import { Address, Hex } from "viem";

import type {
  VectorParams,
  MotionParams,
  PotentialParams,
  ForceParams,
} from "../components/csp/forms";

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
  const initiateVector = async (data: VectorParams) => {
    const { capacity, lifetime, insight } = data;
    const tx = await worldContract.write.csp__initiateVector([
      capacity,
      lifetime + BigInt(Date.now()),
      insight,
    ]);
    await waitForTransaction(tx);
  };

  const archiveVector = async (vectorId: Hex) => {
    const tx = await worldContract.write.csp__archiveVector([vectorId]);
    await waitForTransaction(tx);
  };

  const transferVector = async (vectorId: Hex, newHolder: Address) => {
    const tx = await worldContract.write.csp__transferVector([
      vectorId,
      newHolder,
    ]);
    await waitForTransaction(tx);
  };

  const createDelta = async (data: PotentialParams) => {
    const { vectorId, strength } = data;
    const tx = await worldContract.write.csp__storeEnergy([vectorId, strength]);
    await waitForTransaction(tx);
  };

  const releaseHeat = async (vectorId: Hex) => {
    const tx = await worldContract.write.csp__releaseEnergy([vectorId]);
    await waitForTransaction(tx);
  };

  const initiateMotion = async (data: MotionParams) => {
    const { vectorId, momentum, lifetime, target, insight } = data;
    const tx = await worldContract.write.csp__initiateMotion([
      vectorId,
      momentum,
      lifetime,
      target,
      insight,
    ]);
    await waitForTransaction(tx);
  };

  const executeMotion = async (motionId: Hex) => {
    const tx = await worldContract.write.csp__executeMotion([motionId]);
    await waitForTransaction(tx);
  };

  const cancelMotion = async (motionId: Hex) => {
    const tx = await worldContract.write.csp__cancelMotion([motionId]);
    await waitForTransaction(tx);
  };

  const applyForce = async (data: ForceParams) => {
    const { motionId, direction, insight } = data;
    const tx = await worldContract.write.csp__applyForce([
      motionId,
      direction,
      insight,
    ]);
    await waitForTransaction(tx);
  };

  return {
    initiateVector,
    archiveVector,
    transferVector,
    createDelta,
    releaseHeat,
    initiateMotion,
    cancelMotion,
    executeMotion,
    applyForce,
  };
}
