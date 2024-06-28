// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { IWorld } from "@interface/IWorld.sol";
import { IERC20Mintable } from "@latticexyz/world-modules/src/modules/erc20-puppet/IERC20Mintable.sol";
import { ERC20Module } from "@latticexyz/world-modules/src/modules/erc20-puppet/ERC20Module.sol";
import { registerERC20 } from "@latticexyz/world-modules/src/modules/erc20-puppet/registerERC20.sol";

import { ERC20MetadataData } from "@latticexyz/world-modules/src/modules/erc20-puppet/tables/ERC20Metadata.sol";
import { PuppetModule } from "@latticexyz/world-modules/src/modules/puppet/PuppetModule.sol";

import { CSSystemTokenTable, CSSystemTokenTableData, CSPContractAddress } from "@storage/index.sol";

import { BytesUtils, StringUtils } from "@utils/index.sol";

import { MintPATKN } from "@scripts/MintPATKN.s.sol";
import { DemoSetup } from "@scripts/DemoSetup.s.sol";

import { ScriptWithSetup } from "@utils/Setup.sol";

contract PostDeploy is ScriptWithSetup {
  using StringUtils for string;

  function run(address worldAddress) external {
    StoreSwitch.setStoreAddress(worldAddress);
    IBaseWorld world = IBaseWorld(worldAddress);

    // - Token Info
    bytes14 namespace = (vm.envString("TOKEN_NAMESPACE")).stringToBytes14();
    string memory name = vm.envString("TOKEN_NAME");
    string memory symbol = vm.envString("TOKEN_SYMBOL");
    uint8 decimals = uint8(vm.envUint("TOKEN_DECIMALS"));

    // END ----------- Loading Env Vars

    // BEGIN ----------- Deploying an ERC20 Token
    vm.startBroadcast(user0PrivateKey);

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

    // - Register the contract address
    address contractAddress = IWorld(worldAddress).csp__registerContractAddress();

    // - Mint to all default users
    MintPATKN mintScript = new MintPATKN();
    mintScript.run(worldAddress);

    // - Approve the contract

    vm.startPrank(user2Address);
    erc20Token.approve(contractAddress, 10000);
    vm.stopPrank();

    uint balance = erc20Token.balanceOf(user2Address);
    console.log(user2Address, balance);
    uint allowance = erc20Token.allowance(user2Address, contractAddress);
    console.log(contractAddress, allowance);

    // - Perform setup
    // DemoSetup setupScript = new DemoSetup();
    // setupScript.run(worldAddress);

    // END ----------- Deploying an ERC20 Token
  }
}
