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

import { ScriptWithSetup } from "@utils/Setup.sol";
import { BytesUtils, StringUtils } from "@utils/index.sol";

import { TOKEN_SYMBOL } from "@constants/globals.sol";

contract MintPATKN is ScriptWithSetup {
  using BytesUtils for bytes32;
  using StringUtils for string;

  function run(address worldAddress) external {
    StoreSwitch.setStoreAddress(worldAddress);

    // BEGIN ----------- Minting PATKN ERC20 Token to all anvil default accounts
    uint256 amount = 10000000000;

    vm.startBroadcast(user0PrivateKey);

    // Minting an amount of token to all default anvil wallets
    IERC20Mintable erc20 = TOKEN_SYMBOL.getToken();

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
