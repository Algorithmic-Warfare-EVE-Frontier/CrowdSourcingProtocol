// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { MudTest } from "@latticexyz/world/test/MudTest.t.sol";

import { IWorld } from "../../src/codegen/world/IWorld.sol";
import { CSVectorsTable, CSVectorsTableData, CSPotentialsTable, CSPotentialsTableData, CSVectorPotentialsLookupTable, CSMotionsTable, CSMotionsTableData } from "../../src/codegen/index.sol";
import { VectorStatus, MotionStatus, ForceDirection } from "../../src/codegen/common.sol";
import { TestWithSetup } from "../SystemTestSetups.sol";

contract MotionsTest is TestWithSetup {
  function testMotionInitiated() public {
    // uint256 initiatorPrivateKey = vm.envUint("PRIVATE_KEY");
    // address user3PublicKey = vm.envAddress("PUBLIC_KEY_3");
    // bytes32 vectorId = prepareDischargingVector();
    // vm.startBroadcast(initiatorPrivateKey);
    // // -------------------------------------
    // // Given
    // CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    // console.log(vector.charge);
    // // Then
    // assertTrue(vector.status == VectorStatus.DISCHARGING);
    // // When
    // bytes32 motionId = IWorld(worldAddress).csp__initiateMotion(
    //   vectorId,
    //   1000,
    //   block.timestamp + 1 days,
    //   user3PublicKey,
    //   "This is a sample motion."
    // );
    // CSMotionsTableData memory motion = CSMotionsTable.get(motionId);
    // // Then
    // assertEq(motion.target, user3PublicKey);
    // assertEq(motion.momentum, 1000);
    // assertTrue(motion.status == MotionStatus.PENDING);
    // // -------------------------------------
    // vm.stopBroadcast();
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
    // uint256 initiatorPrivateKey = vm.envUint("PRIVATE_KEY");
    // vm.startBroadcast(initiatorPrivateKey);
    // // -------------------------------------
    // // Given
    // // When
    // // Then
    // // -------------------------------------
    // vm.stopBroadcast();
  }
}
