// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { IERC20Mintable } from "@latticexyz/world-modules/src/modules/erc20-puppet/IERC20Mintable.sol";
import { ERC20Module } from "@latticexyz/world-modules/src/modules/erc20-puppet/ERC20Module.sol";
import { registerERC20 } from "@latticexyz/world-modules/src/modules/erc20-puppet/registerERC20.sol";

import { ERC20MetadataData } from "@latticexyz/world-modules/src/modules/erc20-puppet/tables/ERC20Metadata.sol";
import { PuppetModule } from "@latticexyz/world-modules/src/modules/puppet/PuppetModule.sol";

import { CSVectorsTable, CSVectorsTableData, CSVectorPotentialsLookupTable, CSVectorPotentialsLookupTable, CSForcesTable, CSForcesTableData, CSMotionsTable, CSMotionsTableData, CSMotionForcesLookupTable, CSMotionForcesLookupTable, CSVectorPotentialsLookupTable, CSPotentialsTable, CSPotentialsTableData, CSSystemTokenTable, CSSystemTokenTableData } from "@storage/index.sol";
import { VectorStatus, MotionStatus, ForceDirection } from "@storage/common.sol";

import { BytesUtils, StringUtils } from "@utils/index.sol";

contract MintPATKN is Script {
  using BytesUtils for bytes32;
  using StringUtils for string;

  function run(address worldAddress) external {
    StoreSwitch.setStoreAddress(worldAddress);

    // BEGIN ----------- Loading Env Vars
    // Private Keys
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

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
    // END ----------- Loading Env Vars

    // BEGIN ----------- Minting PATKN ERC20 Token to all anvil default accounts
    uint256 amount = 10000000000;

    vm.startBroadcast(deployerPrivateKey);

    // Minting an amount of token to all default anvil wallets
    string memory tokenSymbol = "PATKN";
    IERC20Mintable erc20 = tokenSymbol.stringToBytes32().getToken();

    erc20.mint(user1Address, amount * 1 ether);
    console.log("minting to: ", address(user1Address));
    console.log("amount: ", erc20.balanceOf(user1Address) * 1 ether);

    erc20.mint(user2Address, amount * 1 ether);
    console.log("minting to: ", address(user2Address));
    console.log("amount: ", erc20.balanceOf(user2Address) * 1 ether);

    erc20.mint(user3Address, amount * 1 ether);
    console.log("minting to: ", address(user3Address));
    console.log("amount: ", erc20.balanceOf(user3Address) * 1 ether);

    erc20.mint(user4Address, amount * 1 ether);
    console.log("minting to: ", address(user4Address));
    console.log("amount: ", erc20.balanceOf(user4Address) * 1 ether);

    erc20.mint(user5Address, amount * 1 ether);
    console.log("minting to: ", address(user5Address));
    console.log("amount: ", erc20.balanceOf(user5Address) * 1 ether);

    erc20.mint(user6Address, amount * 1 ether);
    console.log("minting to: ", address(user6Address));
    console.log("amount: ", erc20.balanceOf(user6Address) * 1 ether);

    erc20.mint(user7Address, amount * 1 ether);
    console.log("minting to: ", address(user7Address));
    console.log("amount: ", erc20.balanceOf(user7Address) * 1 ether);

    erc20.mint(user8Address, amount * 1 ether);
    console.log("minting to: ", address(user8Address));
    console.log("amount: ", erc20.balanceOf(user8Address) * 1 ether);

    erc20.mint(user9Address, amount * 1 ether);
    console.log("minting to: ", address(user9Address));
    console.log("amount: ", erc20.balanceOf(user9Address) * 1 ether);

    vm.stopBroadcast();

    // END ----------- Minting PATKN ERC20 Token to all anvil default accounts
  }
}
