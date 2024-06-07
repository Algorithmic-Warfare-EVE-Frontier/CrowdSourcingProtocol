// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { PuppetModule } from "@latticexyz/world-modules/src/modules/puppet/PuppetModule.sol";
import { IERC20Mintable } from "@latticexyz/world-modules/src/modules/erc20-puppet/IERC20Mintable.sol";
import { ERC20Module } from "@latticexyz/world-modules/src/modules/erc20-puppet/ERC20Module.sol";
import { registerERC20 } from "@latticexyz/world-modules/src/modules/erc20-puppet/registerERC20.sol";

import { ERC20MetadataData } from "@latticexyz/world-modules/src/modules/erc20-puppet/tables/ERC20Metadata.sol";

contract MintERC20 is Script {
  function run(address worldAddress) external {
    // Private key for the ERC20 Contract owner/deployer loaded from ENV
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    address user1PublicAddress = vm.envAddress("PUBLIC_KEY_1");
    address user2PublicAddress = vm.envAddress("PUBLIC_KEY_2");
    address user3PublicAddress = vm.envAddress("PUBLIC_KEY_3");
    address user4PublicAddress = vm.envAddress("PUBLIC_KEY_4");
    address user5PublicAddress = vm.envAddress("PUBLIC_KEY_5");

    address eveTokenAddress = vm.envAddress("LOCAL_EVE_TOKEN");

    // Test parameters hardcoded
    // TODO accept as parameters to the run method for test reproducability
    // Contract address for the deployed token to be minted
    address erc20Address = address(eveTokenAddress);

    // The address of the recipient
    uint256 amount = 1000000000000;

    StoreSwitch.setStoreAddress(worldAddress);
    IBaseWorld world = IBaseWorld(worldAddress);

    vm.startBroadcast(deployerPrivateKey);
    // TODO: Need to make a ERC20 Factory that feeds into the static data module
    StoreSwitch.setStoreAddress(address(world));
    IERC20Mintable erc20 = IERC20Mintable(erc20Address);

    erc20.mint(user1PublicAddress, amount * 1 ether);
    console.log("minting to: ", address(user1PublicAddress));
    console.log("amount: ", amount * 1 ether);

    console.log("Balance of ", user1PublicAddress, ": ", erc20.balanceOf(user1PublicAddress));

    erc20.mint(user2PublicAddress, amount * 1 ether);
    console.log("minting to: ", address(user2PublicAddress));
    console.log("amount: ", amount * 1 ether);

    console.log("Balance of ", user2PublicAddress, ": ", erc20.balanceOf(user2PublicAddress));

    erc20.mint(user3PublicAddress, amount * 1 ether);
    console.log("minting to: ", address(user3PublicAddress));
    console.log("amount: ", amount * 1 ether);

    console.log("Balance of ", user3PublicAddress, ": ", erc20.balanceOf(user3PublicAddress));

    erc20.mint(user4PublicAddress, amount * 1 ether);
    console.log("minting to: ", address(user4PublicAddress));
    console.log("amount: ", amount * 1 ether);

    console.log("Balance of ", user4PublicAddress, ": ", erc20.balanceOf(user4PublicAddress));

    erc20.mint(user5PublicAddress, amount * 1 ether);
    console.log("minting to: ", address(user5PublicAddress));
    console.log("amount: ", amount * 1 ether);

    console.log("Balance of ", user5PublicAddress, ": ", erc20.balanceOf(user5PublicAddress));

    vm.stopBroadcast();
  }
}
