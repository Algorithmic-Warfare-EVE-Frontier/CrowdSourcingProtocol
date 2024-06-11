// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { MudTest } from "@latticexyz/world/test/MudTest.t.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";
import { CSVectorsTable, CSVectorsTableData, CSPotentialsTable, CSPotentialsTableData, CSVectorPotentialsLookupTable } from "../src/codegen/index.sol";
import { VectorStatus } from "../src/codegen/common.sol";

contract MotionsTest is MudTest {
  function testDeltaCreation() public {
    uint256 initiatorPrivateKey = vm.envUint("PRIVATE_KEY_1");
    address initiatorPublicKey = vm.envAddress("PUBLIC_KEY_1");

    bytes32 vectorId = prepareSampleVector();

    vm.startBroadcast(initiatorPrivateKey);
    // -------------------------------------

    // Given

    // When
    bytes32 potentialId = IWorld(worldAddress).csp__createDelta(vectorId, 10000);

    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    CSPotentialsTableData memory potential = CSPotentialsTable.get(potentialId);
    bytes32[] memory potentialIds = CSVectorPotentialsLookupTable.get(vectorId);

    // Then
    assertEq(potential.source, initiatorPublicKey);
    assertEq(potential.strength, 10000);
    assertEq(vector.charge, 10000);
    assertEq(potential.vectorId, vectorId);
    assertEq(potentialIds[0], potentialId);

    // -------------------------------------
    vm.stopBroadcast();
  }

  function testHeatRelease() public {
    uint256 initiatorPrivateKey = vm.envUint("PRIVATE_KEY");
    uint256 potentialPrivateKey = vm.envUint("PRIVATE_KEY_1");

    bytes32 vectorId = prepareSampleVector();

    // -------------------------------------

    // Given
    vm.startBroadcast(potentialPrivateKey);
    IWorld(worldAddress).csp__createDelta(vectorId, 10000);
    vm.stopBroadcast();

    vm.startBroadcast(initiatorPrivateKey);
    IWorld(worldAddress).csp__archiveVector(vectorId);
    vm.stopBroadcast();

    // When
    vm.startBroadcast(potentialPrivateKey);
    IWorld(worldAddress).csp__releaseHeat(vectorId);
    vm.stopBroadcast();

    // Then
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);

    assertEq(vector.charge, 0);

    // -------------------------------------
  }

  function prepareSampleVector() public returns (bytes32) {
    uint256 initiatorPrivateKey = vm.envUint("PRIVATE_KEY");

    vm.startBroadcast(initiatorPrivateKey);
    // -------------------------------------

    uint256 capacity = 30000;
    uint256 lifetime = block.timestamp + 5 days;
    string memory insight = "Trust me, it will work.";

    bytes32 vectorId = IWorld(worldAddress).csp__initiateVector(capacity, lifetime, insight);

    // -------------------------------------
    vm.stopBroadcast();

    return vectorId;
  }
}
