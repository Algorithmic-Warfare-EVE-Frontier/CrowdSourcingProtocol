// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { MudTest } from "@latticexyz/world/test/MudTest.t.sol";

import { IWorld } from "../../src/codegen/world/IWorld.sol";
import { CSVectorsTable, CSVectorsTableData, CSPotentialsTable, CSPotentialsTableData, CSVectorPotentialsLookupTable } from "../../src/codegen/index.sol";
import { VectorStatus } from "../../src/codegen/common.sol";
import { TestWithSetup } from "../SystemTestSetups.sol";

contract MotionsTest is TestWithSetup {
  function testStoreEnergy() public {
    // address user1Address = vm.envAddress("PUBLIC_KEY_1");
    // vm.startPrank(user1Address);
    // // -------------------------------------
    // // Given
    // bytes32 vectorId = prepareVectorInitiatedBy(user1Address, 300000);
    // // When
    // bytes32 potentialId = IWorld(worldAddress).csp__storeEnergy(vectorId, 10000);
    // CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    // CSPotentialsTableData memory potential = CSPotentialsTable.get(potentialId);
    // bytes32[] memory potentialIds = CSVectorPotentialsLookupTable.get(vectorId);
    // // Then
    // assertEq(potential.source, user1Address);
    // assertEq(potential.strength, 10000);
    // assertEq(vector.charge, 10000);
    // assertEq(potential.vectorId, vectorId);
    // assertEq(potentialIds[0], potentialId);
    // // -------------------------------------
    // vm.stopPrank();
  }

  function testReleaseEnergy() public {
    // -------------------------------------
    // Given
    // bytes32 vectorId = prepareVectorInitiatedBy(user1Address, 30000);
    // CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    // uint amount = 10000;
    // // When
    // vm.startPrank(user2Address);
    // IWorld(worldAddress).csp__storeEnergy(vectorId, amount);
    // vm.stopPrank();
    // // Then
    // assertEq(vector.charge, amount);
    // // When
    // vm.startPrank(user1Address);
    // IWorld(worldAddress).csp__archiveVector(vectorId);
    // vm.stopBroadcast();
    // // Then
    // assertTrue(vector.status == VectorStatus.ARCHIVED);
    // // When
    // vm.startBroadcast(user2Address);
    // IWorld(worldAddress).csp__releaseEnergy(vectorId);
    // vm.stopBroadcast();
    // // Then
    // assertEq(vector.charge, 0);
    // -------------------------------------
  }
}
