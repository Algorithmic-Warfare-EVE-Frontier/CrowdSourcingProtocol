// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { MudTest } from "@latticexyz/world/test/MudTest.t.sol";

import { console } from "forge-std/console.sol";

import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { IWorld } from "@interface/IWorld.sol";

import { CSVectorsTable, CSVectorsTableData, CSVectorPotentialsLookupTable, CSVectorPotentialsLookupTable, CSForcesTable, CSForcesTableData, CSMotionsTable, CSMotionsTableData, CSMotionForcesLookupTable, CSMotionForcesLookupTable, CSVectorPotentialsLookupTable, CSPotentialsTable, CSPotentialsTableData, CSSystemTokenTable, CSSystemTokenTableData } from "@storage/index.sol";

import { VectorStatus, MotionStatus, ForceDirection } from "@storage/common.sol";

contract TestWithSetup is MudTest {
  // Private Keys
  uint256 user0PrivateKey = vm.envUint("PRIVATE_KEY");
  uint256 user1PrivateKey = vm.envUint("PRIVATE_KEY_1");
  uint256 user2PrivateKey = vm.envUint("PRIVATE_KEY_2");
  uint256 user3PrivateKey = vm.envUint("PRIVATE_KEY_3");
  uint256 user4PrivateKey = vm.envUint("PRIVATE_KEY_4");
  uint256 user5PrivateKey = vm.envUint("PRIVATE_KEY_5");
  uint256 user6PrivateKey = vm.envUint("PRIVATE_KEY_6");
  uint256 user7PrivateKey = vm.envUint("PRIVATE_KEY_7");
  uint256 user8PrivateKey = vm.envUint("PRIVATE_KEY_8");
  uint256 userrPrivateKey = vm.envUint("PRIVATE_KEY_9");

  // Addresses
  address user0Address = vm.envAddress("PUBLIC_KEY");
  address user1Address = vm.envAddress("PUBLIC_KEY_1");
  address user2Address = vm.envAddress("PUBLIC_KEY_2");
  address user3Address = vm.envAddress("PUBLIC_KEY_3");
  address user4Address = vm.envAddress("PUBLIC_KEY_4");
  address user5Address = vm.envAddress("PUBLIC_KEY_5");
  address user6Address = vm.envAddress("PUBLIC_KEY_6");
  address user7Address = vm.envAddress("PUBLIC_KEY_7");
  address user8Address = vm.envAddress("PUBLIC_KEY_8");
  address user9Address = vm.envAddress("PUBLIC_KEY_9");

  /**
   * Prepares a blank vector for usage.
   * @param userPrivateKey User that initiates a blank vector.
   * @param withCapacity Capacity of the vector.
   * @param withDuration Duration of the vector's active.
   * @param basedOnInsight The information on which the vector's idea rests on.
   */
  function prepareVectorInitiatedBy(
    uint userPrivateKey,
    uint withCapacity,
    uint withDuration,
    string memory basedOnInsight
  ) public returns (bytes32) {
    vm.startBroadcast(userPrivateKey);
    // -------------------------------------

    uint256 capacity = withCapacity;
    uint256 lifetime = block.timestamp + withDuration;
    string memory insight = basedOnInsight;

    bytes32 vectorId = IWorld(worldAddress).csp__initiateVector(capacity, lifetime, insight);

    // -------------------------------------
    vm.stopBroadcast();

    return vectorId;
  }

  /**
   * Make a contribution from a user into a given vector
   * @param user User that makes the contribution as a new potential
   * @param vectorId Vector to which the contribution goes
   * @param amount Amount of tokens to store in the vector
   */
  function storeEnergyIntoVectorAs(address user, bytes32 vectorId, uint amount) public {
    vm.startPrank(user);
    // -------------------------------------

    IWorld(worldAddress).csp__storeEnergy(vectorId, amount);

    // -------------------------------------
    vm.stopPrank();
  }

  function prepareDischargingVector(
    uint userPrivateKey,
    uint capacity,
    uint duration,
    string memory insight,
    address[] memory potentials,
    uint[] memory energies
  ) public returns (bytes32) {
    bytes32 vectorId = prepareVectorInitiatedBy(userPrivateKey, capacity, duration, insight);

    require(potentials.length == energies.length, "The list of potentials and energies must be equal in size.");

    for (uint i = 0; i < potentials.length; i++) {
      storeEnergyIntoVectorAs(potentials[i], vectorId, energies[i]);
    }

    return vectorId;
  }

  function initiateMotion(bytes32 vectorId, address user, uint momentum, address target) public returns (bytes32) {
    vm.startPrank(user);
    // -------------------------------------

    bytes32 motionId = IWorld(worldAddress).csp__initiateMotion(
      vectorId,
      momentum,
      block.timestamp + 1 days,
      target,
      "This is a sample motion."
    );

    // -------------------------------------
    vm.stopPrank();

    return motionId;
  }
}

contract ScriptWithSetup is Script {
  // Private Keys
  uint256 user0PrivateKey = vm.envUint("PRIVATE_KEY");
  uint256 user1PrivateKey = vm.envUint("PRIVATE_KEY_1");
  uint256 user2PrivateKey = vm.envUint("PRIVATE_KEY_2");
  uint256 user3PrivateKey = vm.envUint("PRIVATE_KEY_3");
  uint256 user4PrivateKey = vm.envUint("PRIVATE_KEY_4");
  uint256 user5PrivateKey = vm.envUint("PRIVATE_KEY_5");
  uint256 user6PrivateKey = vm.envUint("PRIVATE_KEY_6");
  uint256 user7PrivateKey = vm.envUint("PRIVATE_KEY_7");
  uint256 user8PrivateKey = vm.envUint("PRIVATE_KEY_8");
  uint256 userrPrivateKey = vm.envUint("PRIVATE_KEY_9");

  // Addresses
  address user0Address = vm.envAddress("PUBLIC_KEY");
  address user1Address = vm.envAddress("PUBLIC_KEY_1");
  address user2Address = vm.envAddress("PUBLIC_KEY_2");
  address user3Address = vm.envAddress("PUBLIC_KEY_3");
  address user4Address = vm.envAddress("PUBLIC_KEY_4");
  address user5Address = vm.envAddress("PUBLIC_KEY_5");
  address user6Address = vm.envAddress("PUBLIC_KEY_6");
  address user7Address = vm.envAddress("PUBLIC_KEY_7");
  address user8Address = vm.envAddress("PUBLIC_KEY_8");
  address user9Address = vm.envAddress("PUBLIC_KEY_9");

  /**
   * Prepares a blank vector for usage.
   * @param userPrivateKey User that initiates a blank vector.
   * @param withCapacity Capacity of the vector.
   * @param withDuration Duration of the vector's active.
   * @param basedOnInsight The information on which the vector's idea rests on.
   */
  function prepareVectorInitiatedBy(
    address worldAddress,
    uint userPrivateKey,
    uint withCapacity,
    uint withDuration,
    string memory basedOnInsight
  ) public returns (bytes32) {
    vm.startBroadcast(userPrivateKey);
    // -------------------------------------

    uint256 capacity = withCapacity;
    uint256 lifetime = block.timestamp + withDuration;
    string memory insight = basedOnInsight;

    bytes32 vectorId = IWorld(worldAddress).csp__initiateVector(capacity, lifetime, insight);

    // -------------------------------------
    vm.stopBroadcast();

    return vectorId;
  }

  /**
   * Make a contribution from a user into a given vector
   * @param user User that makes the contribution as a new potential
   * @param vectorId Vector to which the contribution goes
   * @param amount Amount of tokens to store in the vector
   */
  function storeEnergyIntoVectorAs(address worldAddress, address user, bytes32 vectorId, uint amount) public {
    vm.startPrank(user);
    // -------------------------------------

    IWorld(worldAddress).csp__storeEnergy(vectorId, amount);

    // -------------------------------------
    vm.stopPrank();
  }

  function prepareDischargingVector(
    address worldAddress,
    uint userPrivateKey,
    uint capacity,
    uint duration,
    string memory insight,
    address[] memory potentials,
    uint[] memory energies
  ) public returns (bytes32) {
    bytes32 vectorId = prepareVectorInitiatedBy(worldAddress, userPrivateKey, capacity, duration, insight);

    require(potentials.length == energies.length, "The list of potentials and energies must be equal in size.");

    for (uint i = 0; i < potentials.length; i++) {
      storeEnergyIntoVectorAs(worldAddress, potentials[i], vectorId, energies[i]);
    }

    return vectorId;
  }

  function initiateMotion(
    address worldAddress,
    bytes32 vectorId,
    address user,
    uint momentum,
    address target
  ) public returns (bytes32) {
    vm.startPrank(user);
    // -------------------------------------

    bytes32 motionId = IWorld(worldAddress).csp__initiateMotion(
      vectorId,
      momentum,
      block.timestamp + 1 days,
      target,
      "This is a sample motion."
    );

    // -------------------------------------
    vm.stopPrank();

    return motionId;
  }
}
