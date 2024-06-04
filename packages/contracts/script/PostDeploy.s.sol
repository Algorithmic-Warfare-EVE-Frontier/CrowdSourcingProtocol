// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";
import { ProjectsMetadataTableData } from "../src/codegen/index.sol";

contract PostDeploy is Script {
  function run(address worldAddress) external {
    // Specify a store so that you can use tables directly in PostDeploy
    StoreSwitch.setStoreAddress(worldAddress);

    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    uint256 user2PrivateKey = vm.envUint("PRIVATE_KEY_2");
    uint256 user3PrivateKey = vm.envUint("PRIVATE_KEY_3");
    uint256 user4PrivateKey = vm.envUint("PRIVATE_KEY_4");
    uint256 user5PrivateKey = vm.envUint("PRIVATE_KEY_5");

    // user2 creates a projects
    vm.startBroadcast(user2PrivateKey);

    IWorld(worldAddress).app__create(
      10,
      100,
      uint32(block.timestamp + 5 days),
      "Sample Project",
      "Contribute to my master plan",
      true
    );

    vm.stopBroadcast();

    // user3 makes a contribution
    vm.startBroadcast(user3PrivateKey);

    bytes32 projectId = keccak256(abi.encode("Sample Project"));
    // IWorld(worldAddress).app__contribute(projectId);

    vm.stopBroadcast();
  }
}
