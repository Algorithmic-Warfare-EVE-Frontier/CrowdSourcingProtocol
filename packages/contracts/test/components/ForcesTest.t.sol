// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { MudTest } from "@latticexyz/world/test/MudTest.t.sol";

import { IWorld } from "@interface/IWorld.sol";
import { CSVectorsTable, CSVectorsTableData, CSPotentialsTable, CSPotentialsTableData, CSVectorPotentialsLookupTable, CSMotionsTable, CSMotionsTableData, CSForcesTable, CSForcesTableData } from "@storage/index.sol";
import { VectorStatus, MotionStatus, ForceDirection } from "@storage/common.sol";
import { TestWithSetup } from "@utils/Setup.sol";

contract MotionsTest is TestWithSetup {
  function testApplyForce() public {
    // -------------------------------------
    // // Given
    // address[3] memory potentials = [user2Address, user3Address, user4Address];
    // bytes32 vectorId = prepareDischargingVector(user1Address, 30000, potentials, [10000, 15000, 5000]);
    // // CSMotionsTableData memory motion = CSMotionsTable.get(motionId);
    // bytes32[] memory vectorPotentials = CSVectorPotentialsLookupTable.get(vectorId);
    // bytes32 potentialId;
    // for (uint i = 0; i < vectorPotentials.length; i++) {
    //   potentialId = vectorPotentials[i];
    //   CSPotentialsTableData memory potential = CSPotentialsTable.get(potentialId);
    //   console.log("Source", i, potential.source, potential.strength);
    // }
    // // When
    // vm.startBroadcast(user1PrivateKey);
    // -------------------------------------
    // bytes32 force1Id = IWorld(worldAddress).csp__applyForce(motionId, ForceDirection.ALONG, "I like this motion.");
    // -------------------------------------
    // vm.stopBroadcast();
    // vm.startBroadcast(user2PrivateKey);
    // // -------------------------------------
    // bytes32 force2Id = IWorld(worldAddress).csp__applyForce(
    //   motionId,
    //   ForceDirection.ALONG,
    //   "I could go with this motion."
    // );
    // // -------------------------------------
    // vm.stopBroadcast();
    // Then
    // CSForcesTableData memory force1 = CSForcesTable.get(force1Id);
    // CSForcesTableData memory force2 = CSForcesTable.get(force2Id);
    // CSPotentialsTableData memory potential1 = CSPotentialsTable.get(force1.potentialId);
    // CSPotentialsTableData memory potential2 = CSPotentialsTable.get(force2.potentialId);
    // console.log("Power", force1.power);
    // console.log("Insight", force1.insight);
    // console.log("Source", potential1.source);
    // console.log("Power", force2.power);
    // console.log("Insight", force2.insight);
    // console.log("Source", potential2.source);
    // -------------------------------------
  }
}
