// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { MudTest } from "@latticexyz/world/test/MudTest.t.sol";

import { IWorld } from "@interface/IWorld.sol";
import { CSVectorsTable, CSVectorsTableData, CSPotentialsTable, CSPotentialsTableData, CSVectorPotentialsLookupTable, CSMotionsTable, CSMotionsTableData, CSForcesTable, CSForcesTableData } from "@storage/index.sol";
import { VectorStatus, MotionStatus, ForceDirection } from "@storage/common.sol";

contract TestWithSetup is MudTest {
  // Addresses
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
   * @param user User that initiates a blank vector.
   * @param withCapacity Capacity of the vector.
   */
  function prepareVectorInitiatedBy(address user, uint withCapacity) public returns (bytes32) {
    vm.startPrank(user);
    // -------------------------------------

    uint256 capacity = withCapacity;

    uint256 lifetime = block.timestamp + 5 days;
    string memory insight = "Trust me, it will work.";

    bytes32 vectorId = IWorld(worldAddress).csp__initiateVector(capacity, lifetime, insight);

    // -------------------------------------
    vm.stopPrank();

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
    address user,
    uint capacity,
    address[] memory potentials,
    uint[] memory energies
  ) public returns (bytes32) {
    bytes32 vectorId = prepareVectorInitiatedBy(user, capacity);

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
