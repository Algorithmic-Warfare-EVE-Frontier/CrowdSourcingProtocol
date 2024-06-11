// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CSSystem } from "./CSSystem.sol";
import { CSVectorsTable, CSVectorsTableData, CSMotionsTable, CSMotionsTableData, CSVectorMotionsLookupTable } from "../codegen/index.sol";
import { MotionStatus } from "../codegen/common.sol";
import { CSFilters } from "./shared.sol";

contract CSMotionSystem is CSSystem {
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

  function executeMotion(bytes32 motionId) public onlyProceeding(motionId) {
    CSMotionsTableData memory motion = CSMotionsTable.get(motionId);
    CSVectorsTableData memory vector = CSVectorsTable.get(motion.vectorId);

    CSVectorsTable.setCharge(motion.vectorId, vector.charge - motion.momentum);
  }

  function cancelMotion(bytes32 motionId) public {
    CSMotionsTable.setStatus(motionId, MotionStatus.CANCELLED);
  }
}
