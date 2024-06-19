// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { MudTest } from "@latticexyz/world/test/MudTest.t.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";
import { CSVectorsTable, CSVectorsTableData, CSPotentialsTable, CSPotentialsTableData, CSVectorPotentialsLookupTable, CSMotionsTable, CSMotionsTableData } from "../src/codegen/index.sol";
import { VectorStatus, MotionStatus, ForceDirection } from "../src/codegen/common.sol";

contract MotionsTest is MudTest {
  function testMotionInitiated() public {
    uint256 initiatorPrivateKey = vm.envUint("PRIVATE_KEY");

    address user3PublicKey = vm.envAddress("PUBLIC_KEY_3");

    bytes32 vectorId = prepareDischargingVector();

    vm.startBroadcast(initiatorPrivateKey);
    // -------------------------------------

    // Given
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    console.log(vector.charge);

    // Then
    assertTrue(vector.status == VectorStatus.DISCHARGING);

    // When
    bytes32 motionId = IWorld(worldAddress).csp__initiateMotion(
      vectorId,
      1000,
      block.timestamp + 1 days,
      user3PublicKey,
      "This is a sample motion."
    );

    CSMotionsTableData memory motion = CSMotionsTable.get(motionId);

    // Then
    assertEq(motion.target, user3PublicKey);
    assertEq(motion.momentum, 1000);
    assertTrue(motion.status == MotionStatus.PENDING);

    // -------------------------------------
    vm.stopBroadcast();
  }

  // function testMotionExecuted() public {
  //   uint256 initiatorPrivateKey = vm.envUint("PRIVATE_KEY");
  //   bytes32 motionId = prepareDischarginVectorWithProceedingMotion();

  //   vm.startBroadcast(initiatorPrivateKey);
  //   // -------------------------------------

  //   // Given

  //   CSMotionsTableData memory motion = CSMotionsTable.get(motionId);
  //   console.log("Push", motion.push);
  //   console.log("Pull", motion.pull);
  //   uint256 oldCharge = CSVectorsTable.getCharge(motion.vectorId);

  //   assertTrue(motion.push > 50);

  //   // When
  //   IWorld(worldAddress).csp__executeMotion(motionId);

  //   // Then
  //   uint256 newCharge = CSVectorsTable.getCharge(motion.vectorId);
  //   assertTrue(motion.momentum == oldCharge - newCharge);

  //   // -------------------------------------
  //   vm.stopBroadcast();
  // }

  function testMotionCancelled() public {
    uint256 initiatorPrivateKey = vm.envUint("PRIVATE_KEY");

    vm.startBroadcast(initiatorPrivateKey);
    // -------------------------------------

    // Given

    // When

    // Then

    // -------------------------------------
    vm.stopBroadcast();
  }

  function prepareDischargingVector() public returns (bytes32) {
    uint256 initiatorPrivateKey = vm.envUint("PRIVATE_KEY");
    uint256 user1PrivateKey = vm.envUint("PRIVATE_KEY_1");
    uint256 user2PrivateKey = vm.envUint("PRIVATE_KEY_2");
    // uint256 user3PrivateKey = vm.envUint("PRIVATE_KEY_3");

    vm.startBroadcast(initiatorPrivateKey);
    // -------------------------------------

    uint256 capacity = 30000;
    uint256 lifetime = block.timestamp + 5 days;
    string memory insight = "Trust me, it will work.";

    bytes32 vectorId = IWorld(worldAddress).csp__initiateVector(capacity, lifetime, insight);

    // -------------------------------------
    vm.stopBroadcast();

    vm.startBroadcast(user1PrivateKey);
    // -------------------------------------

    IWorld(worldAddress).csp__createDelta(vectorId, 10000);

    // -------------------------------------
    vm.stopBroadcast();

    vm.startBroadcast(user2PrivateKey);
    // -------------------------------------

    IWorld(worldAddress).csp__createDelta(vectorId, 20000);

    // -------------------------------------
    vm.stopBroadcast();

    // Activate this section to see that you cannot over-charge a vector.
    // vm.startBroadcast(user3PrivateKey);
    // // -------------------------------------

    // IWorld(worldAddress).csp__createDelta(vectorId, 20000);

    // // -------------------------------------
    // vm.stopBroadcast();

    return vectorId;
  }

  function prepareDischarginVectorWithProceedingMotion() public returns (bytes32) {
    bytes32 vectorId = prepareDischargingVector();
    uint256 initiatorPrivateKey = vm.envUint("PRIVATE_KEY");
    uint256 user1PrivateKey = vm.envUint("PRIVATE_KEY_1");
    uint256 user2PrivateKey = vm.envUint("PRIVATE_KEY_2");

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

    vm.startBroadcast(user2PrivateKey);
    // -------------------------------------

    IWorld(worldAddress).csp__applyForce(motionId, ForceDirection.ALONG, "I like this motion.");

    // -------------------------------------
    vm.stopBroadcast();
    vm.startBroadcast(user1PrivateKey);
    // -------------------------------------

    IWorld(worldAddress).csp__applyForce(motionId, ForceDirection.ALONG, "I like this motion.");

    // -------------------------------------
    vm.stopBroadcast();

    return motionId;
  }
}
