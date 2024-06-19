// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CSSystem } from "./CSSystem.sol";
import { CSVectorsTable, CSVectorsTableData } from "../codegen/index.sol";
import { VectorStatus } from "../codegen/common.sol";

/**
 * @title Crowd Sourcing Protocol - Vector System
 * @author Abderraouf "k-symplex" Belalia<abderraoufbelalia@symplectic.link>
 * @notice This system defines the main API of vector handling.
 */
contract CSVectorSystem is CSSystem {
  /**
   * Initiate a "space project" vector.
   * @param capacity The target amount of tokens "energy" necessary to activate the vector.
   * @param lifetime The window of time within which this vector should achieve its activation.
   * @param insight Description of the insight behind the vector.
   */
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

  /**
   * Archive a vector.
   * @param vectorId Identifier of the vector.
   */
  function archiveVector(bytes32 vectorId) public onlyHandler(vectorId) {
    CSVectorsTable.setStatus(vectorId, VectorStatus.ARCHIVED);
  }

  /**
   * Transfer ownership of the vector.
   * @param vectorId Identifier of the vector
   * @param newHandler Address of the new owner
   */
  function transferVector(bytes32 vectorId, address newHandler) public onlyHandler(vectorId) {
    CSVectorsTable.setHandler(vectorId, newHandler);
  }
}
