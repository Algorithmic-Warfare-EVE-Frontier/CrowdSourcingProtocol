// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

// import "@openzeppelin/contracts/math/SafeMath.sol";
import { System } from "@latticexyz/world/src/System.sol";

import { CSVectorsTable, CSVectorsTableData, CSVectorPotentialsLookupTable, CSVectorPotentialsLookupTable, CSForcesTable, CSForcesTableData, CSMotionsTable, CSMotionsTableData, CSMotionForcesLookupTable, CSMotionForcesLookupTable, CSVectorPotentialsLookupTable, CSPotentialsTable, CSPotentialsTableData } from "../codegen/index.sol";

import { VectorStatus, MotionStatus } from "../codegen/common.sol";

contract CSSystem is System {
  //using SafeMath for uint256;

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
    require(vector.status == VectorStatus.ARCHIVED, "Requires vector to be archived.");
    _;
  }

  modifier whenDischarging(bytes32 vectorId) {
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    require(vector.status == VectorStatus.DISCHARGING, "Requires vector to be dicharging.");
    _;
  }

  modifier whenChanneling(bytes32 vectorId) {
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    require(vector.status == VectorStatus.CHANNELING, "Requires vector to be channeling.");
    _;
  }

  modifier withCapacityThreshold(bytes32 vectorId, uint256 strength) {
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    require(
      strength <= vector.capacity - vector.charge,
      "Requires potential strength to not overload vector capacity."
    );
    _;
  }

  modifier notCancelled(bytes32 motionId) {
    CSMotionsTableData memory motion = CSMotionsTable.get(motionId);
    require(motion.status != MotionStatus.CANCELLED, "Requires motion to not be cancelled.");
    _;
  }

  modifier onlyPending(bytes32 motionId) {
    CSMotionsTableData memory motion = CSMotionsTable.get(motionId);
    require(motion.status == MotionStatus.PENDING, "Requires motion to be pending.");
    _;
  }

  modifier onlyProceeding(bytes32 motionId) {
    CSMotionsTableData memory motion = CSMotionsTable.get(motionId);
    require(motion.status == MotionStatus.PROCEEDING, "Requires motion to be proceeding.");
    _;
  }

  /**
   * This extracts the vectorId associated to a provided motion.
   * @param motionId Identifier of the motion.
   */
  // function computeTangent(bytes32 motionId) public returns (bytes32) {
  //   CSMotionsTableData memory motion = CSMotionsTable.get(motionId);
  //   return motion.vectorId;
  // }
}
