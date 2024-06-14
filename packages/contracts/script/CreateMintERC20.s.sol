// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

// import { Script } from "forge-std/Script.sol";
// import { console } from "forge-std/console.sol";
// import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
// import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
// import { PuppetModule } from "@latticexyz/world-modules/src/modules/puppet/PuppetModule.sol";
// import { IERC20Mintable } from "@latticexyz/world-modules/src/modules/erc20-puppet/IERC20Mintable.sol";
// import { ERC20Module } from "@latticexyz/world-modules/src/modules/erc20-puppet/ERC20Module.sol";
// import { registerERC20 } from "@latticexyz/world-modules/src/modules/erc20-puppet/registerERC20.sol";
//
// import { ERC20MetadataData } from "@latticexyz/world-modules/src/modules/erc20-puppet/tables/ERC20Metadata.sol";
//
// contract CreateMintERC20 is Script {
//   function run(address worldAddress) external {
//     StoreSwitch.setStoreAddress(worldAddress);
//     IBaseWorld world = IBaseWorld(worldAddress);
//
//     uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
//
//     string memory namespace = vm.envString("TOKEN_NAMESPACE");
//     string memory name = vm.envString("TOKEN_NAME");
//     string memory symbol = vm.envString("TOKEN_SYMBOL");
//
//     uint8 decimals = uint8(18);
//
//     uint256 amount = 10000000000;
//
//     address user1PublicAddress = vm.envAddress("PUBLIC_KEY_1");
//     // address user2PublicAddress = vm.envAddress("PUBLIC_KEY_2");
//     // address user3PublicAddress = vm.envAddress("PUBLIC_KEY_3");
//     // address user4PublicAddress = vm.envAddress("PUBLIC_KEY_4");
//     // address user5PublicAddress = vm.envAddress("PUBLIC_KEY_5");
//     // address user6PublicAddress = vm.envAddress("PUBLIC_KEY_6");
//     // address user7PublicAddress = vm.envAddress("PUBLIC_KEY_7");
//     // address user8PublicAddress = vm.envAddress("PUBLIC_KEY_8");
//     // address user9PublicAddress = vm.envAddress("PUBLIC_KEY_9");
//
//     vm.startBroadcast(deployerPrivateKey);
//
//     IERC20Mintable erc20Token;
//     StoreSwitch.setStoreAddress(address(world));
//     erc20Token = registerERC20(
//       world,
//       stringToBytes14(namespace),
//       ERC20MetadataData({ decimals: decimals, name: name, symbol: symbol })
//     );
//
//     console.log("Deploying ERC20 token with address: ", address(erc20Token));
//
//     address erc20Address = address(erc20Token);
//
//     IERC20Mintable erc20 = IERC20Mintable(erc20Address);
//
//     erc20.mint(user1PublicAddress, amount * 1 ether);
//     console.log("minting to: ", address(user1PublicAddress));
//     console.log("amount: ", erc20.balanceOf(user1PublicAddress) * 1 ether);
//
//     // erc20.mint(user2PublicAddress, amount * 1 ether);
//     // console.log("minting to: ", address(user2PublicAddress));
//     // console.log("amount: ", erc20.balanceOf(user2PublicAddress) * 1 ether);
//
//     // erc20.mint(user3PublicAddress, amount * 1 ether);
//     // console.log("minting to: ", address(user3PublicAddress));
//     // console.log("amount: ", erc20.balanceOf(user3PublicAddress) * 1 ether);
//
//     // erc20.mint(user4PublicAddress, amount * 1 ether);
//     // console.log("minting to: ", address(user4PublicAddress));
//     // console.log("amount: ", erc20.balanceOf(user4PublicAddress) * 1 ether);
//
//     // erc20.mint(user5PublicAddress, amount * 1 ether);
//     // console.log("minting to: ", address(user5PublicAddress));
//     // console.log("amount: ", erc20.balanceOf(user5PublicAddress) * 1 ether);
//
//     // erc20.mint(user6PublicAddress, amount * 1 ether);
//     // console.log("minting to: ", address(user6PublicAddress));
//     // console.log("amount: ", erc20.balanceOf(user6PublicAddress) * 1 ether);
//
//     // erc20.mint(user7PublicAddress, amount * 1 ether);
//     // console.log("minting to: ", address(user7PublicAddress));
//     // console.log("amount: ", erc20.balanceOf(user7PublicAddress) * 1 ether);
//
//     // erc20.mint(user8PublicAddress, amount * 1 ether);
//     // console.log("minting to: ", address(user8PublicAddress));
//     // console.log("amount: ", erc20.balanceOf(user8PublicAddress) * 1 ether);
//
//     // erc20.mint(user9PublicAddress, amount * 1 ether);
//     // console.log("minting to: ", address(user9PublicAddress));
//     // console.log("amount: ", erc20.balanceOf(user9PublicAddress) * 1 ether);
//
//     vm.stopBroadcast();
//   }
//
//   function stringToBytes14(string memory str) public pure returns (bytes14) {
//     bytes memory tempBytes = bytes(str);
//
//     // Ensure the bytes array is not longer than 14 bytes.
//     // If it is, this will truncate the array to the first 14 bytes.
//     // If it's shorter, it will be padded with zeros.
//     require(tempBytes.length <= 14, "String too long");
//
//     bytes14 converted;
//     for (uint i = 0; i < tempBytes.length; i++) {
//       converted |= bytes14(tempBytes[i] & 0xFF) >> (i * 8);
//     }
//
//     return converted;
//   }
// }
//

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { PuppetModule } from "@latticexyz/world-modules/src/modules/puppet/PuppetModule.sol";
import { IERC20Mintable } from "@latticexyz/world-modules/src/modules/erc20-puppet/IERC20Mintable.sol";
import { ERC20Module } from "@latticexyz/world-modules/src/modules/erc20-puppet/ERC20Module.sol";
import { registerERC20 } from "@latticexyz/world-modules/src/modules/erc20-puppet/registerERC20.sol";

import { ERC20MetadataData } from "@latticexyz/world-modules/src/modules/erc20-puppet/tables/ERC20Metadata.sol";

contract CreateMintERC20 is Script {
  function run(address worldAddress) external {
    console.log("Test hello.");
    StoreSwitch.setStoreAddress(worldAddress);
    IBaseWorld world = IBaseWorld(worldAddress);

    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    bytes14 namespace = "TestERC20";
    string memory name = "Test Token";
    string memory symbol = "TEST";
    uint8 decimals = uint8(18);
    address to = address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
    uint256 amount = 10000000000;

    vm.startBroadcast(deployerPrivateKey);
    // // TODO: Need to make a ERC20 Factory that feeds into the static data module
    IERC20Mintable erc20Token;
    StoreSwitch.setStoreAddress(address(world));
    erc20Token = registerERC20(world, namespace, ERC20MetadataData({ decimals: decimals, name: name, symbol: symbol }));

    // console.log("Deploying ERC20 token with address: ", address(erc20Token));

    // address erc20Address = address(erc20Token);

    // IERC20Mintable erc20 = IERC20Mintable(erc20Address);
    // erc20.mint(to, amount * 1 ether);

    // console.log("minting to: ", address(to));
    // console.log("amount: ", amount * 1 ether);

    vm.stopBroadcast();
  }

  function stringToBytes14(string memory str) public pure returns (bytes14) {
    bytes memory tempBytes = bytes(str);

    // Ensure the bytes array is not longer than 14 bytes.
    // If it is, this will truncate the array to the first 14 bytes.
    // If it's shorter, it will be padded with zeros.
    require(tempBytes.length <= 14, "String too long");

    bytes14 converted;
    for (uint i = 0; i < tempBytes.length; i++) {
      converted |= bytes14(tempBytes[i] & 0xFF) >> (i * 8);
    }

    return converted;
  }
}
