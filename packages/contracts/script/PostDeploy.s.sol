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

import { CSSystemTokenTable, CSSystemTokenTableData } from "../src/codegen/index.sol";

import { StringBytesConversions } from "../src/utils/string.sol";

contract PostDeploy is Script {
  using StringBytesConversions for string;

  function run(address worldAddress) external {
    StoreSwitch.setStoreAddress(worldAddress);
    IBaseWorld world = IBaseWorld(worldAddress);

    // BEGIN ----------- Loading Env Vars

    // - Private Keys
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    // uint256 user1PrivateKey = vm.envUint("PRIVATE_KEY_1");
    // uint256 user2PrivateKey = vm.envUint("PRIVATE_KEY_2");
    // uint256 user3PrivateKey = vm.envUint("PRIVATE_KEY_3");
    // uint256 user4PrivateKey = vm.envUint("PRIVATE_KEY_4");
    // uint256 user5PrivateKey = vm.envUint("PRIVATE_KEY_5");
    // uint256 user6PrivateKey = vm.envUint("PRIVATE_KEY_6");
    // uint256 user7PrivateKey = vm.envUint("PRIVATE_KEY_7");
    // uint256 user8PrivateKey = vm.envUint("PRIVATE_KEY_8");
    // uint256 userrPrivateKey = vm.envUint("PRIVATE_KEY_9");

    // - Addresses
    // address deployerAddress = vm.envAddress("PUBLIC_KEY");
    // address user1Address = vm.envAddress("PUBLIC_KEY_1");
    // address user2Address = vm.envAddress("PUBLIC_KEY_2");
    // address user3Address = vm.envAddress("PUBLIC_KEY_3");
    // address user4Address = vm.envAddress("PUBLIC_KEY_4");
    // address user5Address = vm.envAddress("PUBLIC_KEY_5");
    // address user6Address = vm.envAddress("PUBLIC_KEY_6");
    // address user7Address = vm.envAddress("PUBLIC_KEY_7");
    // address user8Address = vm.envAddress("PUBLIC_KEY_8");
    // address user9Address = vm.envAddress("PUBLIC_KEY_9");

    // - Token Info
    bytes14 namespace = (vm.envString("TOKEN_NAMESPACE")).stringToBytes14();
    string memory name = vm.envString("TOKEN_NAME");
    string memory symbol = vm.envString("TOKEN_SYMBOL");
    uint8 decimals = uint8(vm.envUint("TOKEN_DECIMALS"));

    // END ----------- Loading Env Vars

    // BEGIN ----------- Deploying an ERC20 Token
    vm.startBroadcast(deployerPrivateKey);

    // - Installing the puppet module, necessary.
    StoreSwitch.setStoreAddress(address(world));
    PuppetModule puppetModule = new PuppetModule();
    world.installModule(puppetModule, new bytes(0));

    // - Register the ERC20 Token
    IERC20Mintable erc20Token;
    StoreSwitch.setStoreAddress(address(world));

    erc20Token = registerERC20(world, namespace, ERC20MetadataData({ decimals: decimals, name: name, symbol: symbol }));

    console.log("Deploying ERC20 token with address: ", address(erc20Token));

    address erc20Address = address(erc20Token);

    // - Register the token in the table
    CSSystemTokenTable.set(
    symbol.stringToBytes32(),
      CSSystemTokenTableData({ tokenAddress: erc20Address, tokenName: name })
    );

    // - Export the token address
    string memory tokens = "";
    string memory finalJson = vm.serializeAddress(tokens, "tokenAddress", erc20Address);
    vm.writeJson(finalJson, "./tokens.json");

    vm.stopBroadcast();

    // END ----------- Deploying an ERC20 Token
  }
}
