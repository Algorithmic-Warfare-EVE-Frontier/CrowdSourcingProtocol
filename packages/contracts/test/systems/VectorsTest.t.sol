// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { MudTest } from "@latticexyz/world/test/MudTest.t.sol";

import { IWorld } from "../../src/codegen/world/IWorld.sol";
import { CSVectorsTable, CSVectorsTableData } from "../../src/codegen/index.sol";
import { VectorStatus } from "../../src/codegen/common.sol";
import { TestWithSetup } from "../SystemTestSetups.sol";

contract VectorsTest is TestWithSetup {
  function testVectorInitiated() public {
    // -------------------------------------

    // Given
    uint256 capacity = 30000;
    uint256 duration = 5 days;
    string memory insight = "Trust me, it will work.";

    // When
    bytes32 vectorId = prepareVectorInitiatedBy(user1PrivateKey, capacity, duration, insight);
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);

    // Then
    assertEq(vector.capacity, 30000);
    assertEq(vector.charge, 0);
    assertEq(vector.handler, user1Address);
    assertEq(vector.insight, "Trust me, it will work.");
    assertTrue(vector.status == VectorStatus.CHANNELING);

    // -------------------------------------
  }

  function testVectorArchived() public {
    // -------------------------------------

    // Given
    uint256 capacity = 30000;
    uint256 duration = 5 days;
    string memory insight = "Trust me, it will work.";

    bytes32 vectorId = prepareVectorInitiatedBy(user1PrivateKey, capacity, duration, insight);

    // When
    vm.startBroadcast(user1PrivateKey);
    IWorld(worldAddress).csp__archiveVector(vectorId);
    vm.stopBroadcast();

    // Then
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    assertTrue(vector.status == VectorStatus.ARCHIVED);

    // -------------------------------------
  }

  function testVectorTransfered() public {
    // -------------------------------------

    // Given
    uint256 capacity = 30000;
    uint256 duration = 5 days;
    string memory insight = "Trust me, it will work.";

    bytes32 vectorId = prepareVectorInitiatedBy(user1PrivateKey, capacity, duration, insight);

    // When
    vm.startBroadcast(user1PrivateKey);
    IWorld(worldAddress).csp__transferVector(vectorId, user2Address);
    vm.stopBroadcast();

    // Then
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    assertEq(vector.handler, user2Address);

    // -------------------------------------
  }
}
