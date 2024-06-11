// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CSSystem } from "./CSSystem.sol";
import { CSVectorsTable, CSVectorsTableData } from "../codegen/index.sol";
import { VectorStatus } from "../codegen/common.sol";
import { CSFilters } from "./shared.sol";

contract CSVectorSystem is CSSystem {
  function initiateVector(uint256 capacity, uint256 lifetime, string memory insight) public returns (bytes32) {
    address handler = tx.origin;
    bytes32 vectorId = keccak256(abi.encodePacked(block.timestamp, block.prevrandao));

    CSVectorsTable.set(
      vectorId,
      CSVectorsTableData({
        handler: handler,
        charge: 0,
        capacity: capacity,
        lifetime: lifetime,
        insight: insight,
        status: VectorStatus.CHANNELING
      })
    );

    return vectorId;
  }

  function archiveVector(bytes32 vectorId) public onlyHandler(vectorId) {
    CSVectorsTable.setStatus(vectorId, VectorStatus.ARCHIVED);
  }

  function transferVector(bytes32 vectorId, address newHandler) public onlyHandler(vectorId) {
    CSVectorsTable.setHandler(vectorId, newHandler);
  }
}
