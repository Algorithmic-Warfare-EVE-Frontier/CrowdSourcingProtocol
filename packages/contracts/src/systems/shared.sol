// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CSVectorsTable, CSVectorsTableData, CSVectorPotentialsLookupTable, CSVectorPotentialsLookupTable, CSForcesTable, CSForcesTableData, CSMotionsTable, CSMotionsTableData, CSMotionForcesLookupTable, CSMotionForcesLookupTable, CSVectorPotentialsLookupTable, CSPotentialsTable, CSPotentialsTableData } from "../codegen/index.sol";

import { VectorStatus } from "../codegen/common.sol";

library CSFilters {
  modifier onlyHandler(bytes32 vectorId) {
    address user = tx.origin;
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    require(user == vector.handler, "Reserved for vector handler only.");
    _;
  }
  modifier notHandler(bytes32 vectorId) {
    address user = tx.origin;
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    require(user != vector.handler, "Reserved for vector handler only.");
    _;
  }

  modifier onlyPotential(bytes32 vectorId) {
    address user = tx.origin;
    bytes32 potentialId;
    bool isPotential = false;
    bytes32[] memory potentialIds = CSVectorPotentialsLookupTable.get(vectorId);

    for (uint i = 0; i < potentialIds.length; i++) {
      potentialId = potentialIds[i];
      CSPotentialsTableData memory potential = CSPotentialsTable.get(potentialId);
      isPotential = (user == potential.source);
      if (isPotential) {
        break;
      }
    }

    require(isPotential, "Reserved for vector potentials only.");
    _;
  }

  modifier notArchived(bytes32 vectorId) {
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    require(vector.status != VectorStatus.ARCHIVED, "Requires vector to not be archived");
    _;
  }
  modifier onlyArchived(bytes32 vectorId) {
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    require(vector.status == VectorStatus.ARCHIVED, "Requires vector to be archived");
    _;
  }
}

library CSAddressUtils {
  function getPotential(address self, bytes32 vectorId) internal view returns (bytes32) {
    bytes32 potentialId;
    CSPotentialsTableData memory potential;

    bytes32[] memory potentialIds = CSVectorPotentialsLookupTable.get(vectorId);

    for (uint i = 0; i < potentialIds.length; i++) {
      potentialId = potentialIds[i];
      potential = CSPotentialsTable.get(potentialId);
      if (self == potential.source) {
        break;
      }
    }

    return potentialId;
  }
}
