// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CSSystem } from "./CSSystem.sol";
import { CSVectorsTable, CSVectorsTableData, CSMotionsTable, CSMotionsTableData, CSVectorMotionsLookupTable } from "../codegen/index.sol";
import { MotionStatus } from "../codegen/common.sol";

/**
 * @title Crowd Sourcing Protocol - Motion System
 * @author Abderraouf "k-symplex" Belalia<abderraoufbelalia@symplectic.link>
 * @notice This system defines the main API of motion handling.
 */
contract CSMotionSystem is CSSystem {
  /**
   * Initiate a motion.
   * @param vectorId Identifier of the vector to which the motion belongs.
   * @param momentum Amount of tokens withdraw in order to execute the motion.
   * @param lifetime Timefram within which the motion should be executed.
   * @param target Address of the recipient of the withdrawn tokens.
   * @param insight Justification behind the motion
   */
  function initiateMotion(
    bytes32 vectorId,
    uint256 momentum,
    uint256 lifetime,
    address target,
    string memory insight
  ) public onlyHandler(vectorId) notArchived(vectorId) whenDischarging(vectorId) returns (bytes32) {
    bytes32 motionId = keccak256(abi.encodePacked(block.timestamp, block.prevrandao));

    CSMotionsTable.set(
      motionId,
      CSMotionsTableData({
        vectorId: vectorId,
        momentum: momentum,
        lifetime: lifetime,
        target: target,
        push: 0,
        pull: 0,
        status: MotionStatus.PENDING,
        insight: insight
      })
    );

    CSVectorMotionsLookupTable.pushMotionIds(vectorId, motionId);

    return motionId;
  }

  /**
   * Executes a motion. After it has been marked as proceeding.
   * @param motionId Identifier of the motion.
   */
  function executeMotion(bytes32 motionId) public payable onlyProceeding(motionId) {
    CSMotionsTableData memory motion = CSMotionsTable.get(motionId);
    CSVectorsTableData memory vector = CSVectorsTable.get(motion.vectorId);

    // erc20.transfer(motion.target, motion.momentum);
    CSVectorsTable.setCharge(motion.vectorId, vector.charge - motion.momentum);
  }

  /**
   * Cancel a motion.
   * @param motionId Identifier of the motion.
   *
   * @dev We need to cap the number of cancel per vector and let's say mark it as failing if it has 3 cancels.
   */
  function cancelMotion(bytes32 motionId) public {
    CSMotionsTable.setStatus(motionId, MotionStatus.CANCELLED);
  }
}
