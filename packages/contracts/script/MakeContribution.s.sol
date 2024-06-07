// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { IWorld } from "../src/codegen/world/IWorld.sol";
import { ContributersTable, ContributersTableData } from "../src/codegen/index.sol";

contract MakeContribution is Script {
  function run(address worldAddress) external {
    // Private Key loaded from environment
    uint256 user2PrivateKey = vm.envUint("PRIVATE_KEY_1");
    address user2PublicAddress = vm.envAddress("PUBLIC_KEY_1");

    vm.startBroadcast(user2PrivateKey);

    uint256 amount = 33;
    address contributor = user2PublicAddress;
    string memory title = "Sample Project";

    bytes32 projectId = keccak256(abi.encode(title));

    IWorld(worldAddress).csp__contribute(projectId, amount);

    ContributersTableData memory contributorData = ContributersTable.get(projectId, contributor);

    console.log("Contributer: ", contributor);
    console.log("Amount: ", contributorData.amount);
    console.log("Voting Power: ", contributorData.votingPower);

    vm.stopBroadcast();
  }
}
