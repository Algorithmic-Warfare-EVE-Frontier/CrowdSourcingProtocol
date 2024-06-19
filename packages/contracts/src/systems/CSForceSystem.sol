// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CSSystem } from "./CSSystem.sol";
import { CSVectorsTable, CSVectorsTableData, CSForcesTable, CSForcesTableData, CSMotionsTable, CSMotionsTableData, CSMotionForcesLookupTable, CSVectorPotentialsLookupTable, CSPotentialsTable, CSPotentialsTableData } from "../codegen/index.sol";
import { MotionStatus, ForceDirection } from "../codegen/common.sol";
import { CSAddressUtils } from "./shared.sol";

/**
 * @title Crowd Sourcing Protocol - Force System
 * @author Abderraouf "k-symplex" Belalia<abderraoufbelalia@symplectic.link>
 * @notice This system defines the main API of force handling.
 */
contract CSForceSystem is CSSystem {
  using CSAddressUtils for address;

  /**
   * Apply force on an issued motion.
   * @param motionId Identifier of the motion.
   * @param direction Whether you support or oppose the motion.
   * @param insight A note to justify your action.
   */
  function applyForce(
    bytes32 motionId,
    ForceDirection direction,
    string memory insight
  ) public onlyPending(motionId) returns (bytes32) {
    address source = tx.origin;

    bytes32 forceId = keccak256(abi.encodePacked(block.timestamp, block.prevrandao));

    bytes32 vectorId = CSMotionsTable.getVectorId(motionId);

    bytes32 potentialId = source.getPotentialId(vectorId);
    CSPotentialsTableData memory potential = CSPotentialsTable.get(potentialId);
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    CSMotionsTableData memory motion = CSMotionsTable.get(motionId);

    uint power = ((potential.strength * 100) / vector.capacity);

    if (direction == ForceDirection.ALONG) {
      CSMotionsTable.setPush(motionId, motion.push + power);
      if (motion.push > 50) {
        motion.status = MotionStatus.PROCEEDING;
      }
    } else {
      CSMotionsTable.setPull(motionId, motion.pull + power);
      if (motion.pull > 50) {
        motion.status = MotionStatus.HALTING;
      }
    }

    CSForcesTable.set(
      forceId,
      CSForcesTableData({
        power: power,
        direction: direction,
        insight: insight,
        motionId: motionId,
        potentialId: potentialId
      })
    );

    CSMotionForcesLookupTable.push(motionId, forceId);

    return forceId;
  }
}
