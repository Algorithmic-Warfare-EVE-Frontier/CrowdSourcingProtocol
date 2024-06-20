// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";

import { CSVectorsTable, CSVectorsTableData, CSVectorPotentialsLookupTable, CSVectorPotentialsLookupTable, CSForcesTable, CSForcesTableData, CSMotionsTable, CSMotionsTableData, CSMotionForcesLookupTable, CSMotionForcesLookupTable, CSVectorPotentialsLookupTable, CSPotentialsTable, CSPotentialsTableData, CSSystemTokenTable, CSSystemTokenTableData } from "../src/codegen/index.sol";

import { VectorStatus, MotionStatus, ForceDirection } from "../src/codegen/common.sol";

contract DemoSetup is Script {
  function run(address worldAddress) external {
    StoreSwitch.setStoreAddress(worldAddress);

    // BEGIN ----------- Loading Env Vars
    // Private Keys
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    // Addresses
    address deployerAddress = vm.envAddress("PUBLIC_KEY");
    address user1Address = vm.envAddress("PUBLIC_KEY_1");
    address user2Address = vm.envAddress("PUBLIC_KEY_2");
    address user3Address = vm.envAddress("PUBLIC_KEY_3");
    address user4Address = vm.envAddress("PUBLIC_KEY_4");
    address user5Address = vm.envAddress("PUBLIC_KEY_5");
    address user6Address = vm.envAddress("PUBLIC_KEY_6");
    address user7Address = vm.envAddress("PUBLIC_KEY_7");
    address user8Address = vm.envAddress("PUBLIC_KEY_8");
    address user9Address = vm.envAddress("PUBLIC_KEY_9");
    // END ----------- Loading Env Vars

    // ----------- Setting Up Tables with Mock Values
    prepareFreshVector(deployerPrivateKey, deployerAddress);
    prepareFreshVectorWithFewPotentials(deployerPrivateKey, deployerAddress, user1Address, user2Address);
  }

  // BEGIN ------------------ System Preparations for Demo purposes
  function prepareFreshVector(uint256 userPrivateKey, address userAddress) internal {
    vm.startBroadcast(userPrivateKey);

    // first vector: just initiated
    bytes32 vectorId = keccak256(abi.encodePacked(block.timestamp));
    address handler = userAddress;
    uint256 capacity = 1000;
    uint256 lifetime = 5000;
    string memory insight = "This is a test vector.";
    CSVectorsTable.set(
      vectorId,
      CSVectorsTableData({
        handler: handler,
        charge: 0,
        capacity: capacity,
        lifetime: lifetime,
        insight: insight,
        status: VectorStatus.CHANNELING
      })
    );

    vm.stopBroadcast();
  }

  function prepareFreshVectorWithFewPotentials(
    uint256 userPrivateKey,
    address userAddress,
    address potential1Address,
    address potential2Address
  ) internal {
    vm.startBroadcast(userPrivateKey);

    bytes32 vectorId = keccak256(abi.encodePacked(block.timestamp + 12));
    address handler = userAddress;
    uint256 capacity = 10000;
    uint256 lifetime = 5000;
    string memory insight = "This is a test vector with few potentials.";
    CSVectorsTable.set(
      vectorId,
      CSVectorsTableData({
        handler: handler,
        charge: 0,
        capacity: capacity,
        lifetime: lifetime,
        insight: insight,
        status: VectorStatus.CHANNELING
      })
    );

    bytes32 potential1Id = keccak256(abi.encodePacked(block.timestamp + 1));
    address source1 = potential1Address;
    uint256 strength1 = 500;
    CSPotentialsTable.set(
      potential1Id,
      CSPotentialsTableData({ source: source1, strength: strength1, vectorId: vectorId })
    );

    CSVectorPotentialsLookupTable.push(vectorId, potential1Id);

    bytes32 potential2Id = keccak256(abi.encodePacked(block.timestamp + 2));
    address source2 = potential2Address;
    uint256 strength2 = 250;
    CSPotentialsTable.set(
      potential2Id,
      CSPotentialsTableData({ source: source2, strength: strength2, vectorId: vectorId })
    );

    CSVectorPotentialsLookupTable.push(vectorId, potential2Id);

    vm.stopBroadcast();
  }

  // END ------------------ System Preparations for Demo purposes
}
