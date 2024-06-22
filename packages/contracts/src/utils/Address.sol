// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CSVectorsTable, CSVectorsTableData, CSVectorPotentialsLookupTable, CSVectorPotentialsLookupTable, CSForcesTable, CSForcesTableData, CSMotionsTable, CSMotionsTableData, CSMotionForcesLookupTable, CSMotionForcesLookupTable, CSVectorPotentialsLookupTable, CSPotentialsTable, CSPotentialsTableData } from "@storage/index.sol";

import { VectorStatus } from "@storage/common.sol";

library AddressUtils {
  /**
   * Obtain the potential ID associated to a given address.
   * @param self Address of the contributor.
   * @param vectorId Identifier of the vector.
   */
  function getPotentialId(address self, bytes32 vectorId) internal view returns (bytes32) {
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
