// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CSSystem } from "./CSSystem.sol";
import { CSVectorsTable, CSVectorsTableData, CSPotentialsTable, CSPotentialsTableData, CSVectorPotentialsLookupTable, CSVectorPotentialsLookupTable } from "../codegen/index.sol";
import { VectorStatus } from "../codegen/common.sol";
import { CSAddressUtils } from "./shared.sol";

contract CSPotentialSystem is CSSystem {
  using CSAddressUtils for address;

  function createDelta(
    bytes32 vectorId,
    uint256 strength
  ) public notHandler(vectorId) withCapacityThreshold(vectorId, strength) whenChanneling(vectorId) returns (bytes32) {
    address source = tx.origin;
    bytes32 potentialId = keccak256(abi.encodePacked(block.timestamp, block.prevrandao));

    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);

    CSPotentialsTable.set(
      potentialId,
      CSPotentialsTableData({ source: source, strength: strength, vectorId: vectorId })
    );

    CSVectorPotentialsLookupTable.push(vectorId, potentialId);
    CSVectorsTable.setCharge(vectorId, vector.charge + strength);

    if (vector.charge + strength == vector.capacity) {
      CSVectorsTable.setStatus(vectorId, VectorStatus.DISCHARGING);
    }

    return potentialId;
  }

  function releaseHeat(bytes32 vectorId) public onlyArchived(vectorId) onlyPotential(vectorId) {
    address source = tx.origin;

    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);

    bytes32 potentialId = source.getPotential(vectorId);
    CSPotentialsTableData memory potential = CSPotentialsTable.get(potentialId);

    // TODO We need to remove the user from the list of potentials.
    CSVectorsTable.setCharge(vectorId, vector.charge - potential.strength);
  }
}
