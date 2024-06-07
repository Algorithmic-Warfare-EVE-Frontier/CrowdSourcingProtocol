// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";

import { ProjectsMetadataTable, ProjectsMetadataTableData, ProjectsDataTable, ProjectsDataTableData } from "../src/codegen/index.sol";

contract PostDeploy is Script {
  function run(address worldAddress) external {
    // // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    vm.startBroadcast(deployerPrivateKey);

    // --------------
    uint32 threshold = 10;
    uint32 target = 100;
    uint32 deadline = uint32(block.timestamp + 5 days);
    string memory title = "Sample Project";
    string memory description = "Just give me your money.";

    IWorld(worldAddress).csp__create(threshold, target, deadline, title, description);

    bytes32 projectId = keccak256(abi.encode(title));

    ProjectsMetadataTableData memory projectMetadata = ProjectsMetadataTable.get(projectId);
    ProjectsDataTableData memory projectData = ProjectsDataTable.get(projectId);

    console.log("Title: ", projectData.title);
    console.log("Description: ", projectData.description);
    console.log("Threshold: ", projectMetadata.threshold);
    console.log("Target: ", projectMetadata.target);

    console.log("Hello world");

    vm.stopBroadcast();
  }
}
