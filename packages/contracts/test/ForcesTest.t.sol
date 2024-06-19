// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { MudTest } from "@latticexyz/world/test/MudTest.t.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";
import { CSVectorsTable, CSVectorsTableData, CSPotentialsTable, CSPotentialsTableData, CSVectorPotentialsLookupTable, CSMotionsTable, CSMotionsTableData, CSForcesTable, CSForcesTableData } from "../src/codegen/index.sol";
import { VectorStatus, MotionStatus, ForceDirection } from "../src/codegen/common.sol";

contract MotionsTest is MudTest {
  function testApplyForce() public {
    uint256 user1PrivateKey = vm.envUint("PRIVATE_KEY_1");
    uint256 user2PrivateKey = vm.envUint("PRIVATE_KEY_2");

    // -------------------------------------

    // Given
    bytes32 vectorId = prepareDischargingVector();
    // CSMotionsTableData memory motion = CSMotionsTable.get(motionId);
    bytes32[] memory vectorPotentials = CSVectorPotentialsLookupTable.get(vectorId);

    bytes32 potentialId;
    for (uint i = 0; i < vectorPotentials.length; i++) {
      potentialId = vectorPotentials[i];
      CSPotentialsTableData memory potential = CSPotentialsTable.get(potentialId);
      console.log("Source", i, potential.source, potential.strength);
    }

    // When
    vm.startBroadcast(user1PrivateKey);
    // -------------------------------------

    // bytes32 force1Id = IWorld(worldAddress).csp__applyForce(motionId, ForceDirection.ALONG, "I like this motion.");

    // -------------------------------------
    vm.stopBroadcast();
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

  function createDeltaWithGivenPotential(uint256 privateKey, bytes32 vectorId, uint256 strength) public {
    vm.startBroadcast(privateKey);
    // -------------------------------------

    IWorld(worldAddress).csp__createDelta(vectorId, strength);

    // -------------------------------------
    vm.stopBroadcast();
  }

  function prepareDischargingVector() public returns (bytes32) {
    uint256 initiatorPrivateKey = vm.envUint("PRIVATE_KEY");
    uint256 user1PrivateKey = vm.envUint("PRIVATE_KEY_1");
    uint256 user2PrivateKey = vm.envUint("PRIVATE_KEY_2");
    uint256 user3PrivateKey = vm.envUint("PRIVATE_KEY_3");
    // address user1PublicKey = vm.envAddress("PUBLIC_KEY_1");
    // address user2PublicKey = vm.envAddress("PUBLIC_KEY_2");

    vm.startBroadcast(initiatorPrivateKey);
    // -------------------------------------

    uint256 capacity = 30000;
    uint256 lifetime = block.timestamp + 5 days;
    string memory insight = "Trust me, it will work.";

    bytes32 vectorId = IWorld(worldAddress).csp__initiateVector(capacity, lifetime, insight);

    // -------------------------------------
    vm.stopBroadcast();

    createDeltaWithGivenPotential(user1PrivateKey, vectorId, 10000);
    // createDeltaWithGivenPotential(user3PrivateKey, vectorId, 20000);

    return vectorId;
  }

  function prepareDischarginVectorWithProceedingMotion() public returns (bytes32) {
    bytes32 vectorId = prepareDischargingVector();
    uint256 initiatorPrivateKey = vm.envUint("PRIVATE_KEY");

    address user3PublicKey = vm.envAddress("PUBLIC_KEY_3");

    vm.startBroadcast(initiatorPrivateKey);
    // -------------------------------------

    bytes32 motionId = IWorld(worldAddress).csp__initiateMotion(
      vectorId,
      1000,
      block.timestamp + 1 days,
      user3PublicKey,
      "This is a sample motion."
    );

    // -------------------------------------
    vm.stopBroadcast();

    return motionId;
  }
}
