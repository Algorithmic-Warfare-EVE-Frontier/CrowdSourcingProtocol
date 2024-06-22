// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { MudTest } from "@latticexyz/world/test/MudTest.t.sol";

import { IWorld } from "../../src/codegen/world/IWorld.sol";
import { CSVectorsTable, CSVectorsTableData } from "../../src/codegen/index.sol";
import { VectorStatus } from "../../src/codegen/common.sol";
import { TestWithSetup } from "../SystemTestSetups.sol";

contract VectorsTest is TestWithSetup {
  // function testVectorInitiated() public {
  //   uint256 initiatorPrivateKey = vm.envUint("PRIVATE_KEY");
  //   vm.startBroadcast(initiatorPrivateKey);
  //   // -------------------------------------
  //   // Given
  //   uint256 capacity = 30000;
  //   uint256 lifetime = block.timestamp + 5 days;
  //   string memory insight = "Trust me, it will work.";
  //   // When
  //   bytes32 vectorId = IWorld(worldAddress).csp__initiateVector(capacity, lifetime, insight);
  //   // Then
  //   CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
  //   assertEq(vector.capacity, 30000);
  //   assertEq(vector.insight, "Trust me, it will work.");
  //   assertTrue(vector.status == VectorStatus.CHANNELING);
  //   // -------------------------------------
  //   vm.stopBroadcast();
  // }
  // function testVectorArchived() public {
  //   uint256 initiatorPrivateKey = vm.envUint("PRIVATE_KEY");
  //   vm.startBroadcast(initiatorPrivateKey);
  //   // -------------------------------------
  //   // Given
  //   uint256 capacity = 30000;
  //   uint256 lifetime = block.timestamp + 5 days;
  //   string memory insight = "Trust me, it will work.";
  //   bytes32 vectorId = IWorld(worldAddress).csp__initiateVector(capacity, lifetime, insight);
  //   // When
  //   IWorld(worldAddress).csp__archiveVector(vectorId);
  //   // Then
  //   CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
  //   assertTrue(vector.status == VectorStatus.ARCHIVED);
  //   // -------------------------------------
  //   vm.stopBroadcast();
  // }
  // function testVectorTransfered() public {
  //   uint256 initiatorPrivateKey = vm.envUint("PRIVATE_KEY");
  //   address initiatorPublicKey = vm.envAddress("PUBLIC_KEY");
  //   address newHandlerPublicKey = vm.envAddress("PUBLIC_KEY_1");
  //   vm.startBroadcast(initiatorPrivateKey);
  //   // -------------------------------------
  //   // Given
  //   uint256 capacity = 30000;
  //   uint256 lifetime = block.timestamp + 5 days;
  //   string memory insight = "Trust me, it will work.";
  //   bytes32 vectorId = IWorld(worldAddress).csp__initiateVector(capacity, lifetime, insight);
  //   // When
  //   IWorld(worldAddress).csp__transferVector(vectorId, newHandlerPublicKey);
  //   // Then
  //   CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
  //   assertFalse(vector.handler == initiatorPublicKey);
  //   assertTrue(vector.handler == newHandlerPublicKey);
  //   // -------------------------------------
  //   vm.stopBroadcast();
  // }
}
