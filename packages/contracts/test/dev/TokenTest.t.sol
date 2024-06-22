// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { MudTest } from "@latticexyz/world/test/MudTest.t.sol";

import { IWorld } from "@interface/IWorld.sol";
import { IERC20Mintable } from "@latticexyz/world-modules/src/modules/erc20-puppet/IERC20Mintable.sol";

import { BytesUtils, StringUtils } from "@utils/index.sol";

import { TOKEN_SYMBOL } from "@constants/globals.sol";

// This has been used in development to check the token work.

// contract TokenTest is MudTest {
//   using TokenSymbolUtils for bytes32;
//   using StringBytesConversions for string;
//
//   function testTokenExists() public {
//     // Given
//     address tokenAddress = TOKEN_ADDRESS;
//     IERC20Mintable erc20FromEnv = IERC20Mintable(tokenAddress);
//
//     // When
//     string memory tokenSymbol = "PATKN";
//     IERC20Mintable erc20FromTable = tokenSymbol.stringToBytes32().getToken();
//
//     // Then
//     assertEq(erc20FromEnv.name(), erc20FromTable.name());
//     assertEq(erc20FromEnv.symbol(), erc20FromTable.symbol());
//     assertEq(erc20FromEnv.totalSupply(), erc20FromTable.totalSupply());
//   }
//
//   function testDefaultAccountsHaveAllowance() public {
//     // Given
//     address tokenAddress = TOKEN_ADDRESS;
//     IERC20Mintable erc20 = IERC20Mintable(tokenAddress);
//
//     // When
//     uint totalSupply = erc20.totalSupply();
//
//     // Then
//     assertEq(totalSupply, 9 * 10000000000 * 1 ether);
//   }
//
//   function testDefaultAccountsCanTransfer() public {
//     // Given
//     address tokenAddress = TOKEN_ADDRESS;
//     IERC20Mintable erc20 = IERC20Mintable(tokenAddress);
//     address user1Address = vm.envAddress("PUBLIC_KEY_1");
//     address user2Address = vm.envAddress("PUBLIC_KEY_2");
//
//     uint amount = 10000 * 1 ether;
//
//     uint balance1Before = erc20.balanceOf(user1Address);
//     uint balance2Before = erc20.balanceOf(user2Address);
//
//     // When
//     vm.prank(user1Address);
//     bool successStatus = erc20.transfer(user2Address, amount);
//
//     uint balance1After = erc20.balanceOf(user1Address);
//     uint balance2After = erc20.balanceOf(user2Address);
//
//     // Then
//     assertTrue(successStatus);
//     assertEq(balance1Before - balance1After, amount);
//     assertEq(balance2After - balance2Before, amount);
//   }
//
//   function testCanInfiniteApprove() public {
//     // Given
//     address tokenAddress = TOKEN_ADDRESS;
//     IERC20Mintable erc20 = IERC20Mintable(tokenAddress);
//     address user1Address = vm.envAddress("PUBLIC_KEY_1");
//     address user2Address = vm.envAddress("PUBLIC_KEY_2");
//
//     uint infiniteAmount = type(uint).max;
//
//     // When
//     vm.prank(user1Address);
//     bool successStatus = erc20.approve(user2Address, infiniteAmount);
//     uint allowance = erc20.allowance(user1Address, user2Address);
//
//     // Then
//     assertTrue(successStatus);
//     assertEq(allowance, infiniteAmount);
//   }
//
//   function testCanTransferFrom() public {
//     // Given
//     address tokenAddress = TOKEN_ADDRESS;
//     IERC20Mintable erc20 = IERC20Mintable(tokenAddress);
//     address user1Address = vm.envAddress("PUBLIC_KEY_1");
//     address user2Address = vm.envAddress("PUBLIC_KEY_2");
//     address user3Address = vm.envAddress("PUBLIC_KEY_3");
//
//     uint infiniteAmount = type(uint).max;
//     vm.startPrank(user1Address);
//     erc20.approve(user2Address, infiniteAmount);
//     vm.stopPrank();
//
//     uint transferAmount1 = 12 * 1 ether;
//     uint transferAmount2 = 98 * 1 ether;
//
//     uint balance1Before = erc20.balanceOf(user1Address);
//     uint balance2Before = erc20.balanceOf(user2Address);
//     uint balance3Before = erc20.balanceOf(user3Address);
//
//     // When
//     vm.startPrank(user2Address);
//     bool transfer1SuccessStatus = erc20.transferFrom(user1Address, user3Address, transferAmount1);
//     bool transfer2SuccessStatus = erc20.transferFrom(user1Address, user2Address, transferAmount2);
//     vm.stopPrank();
//
//     uint balance1After = erc20.balanceOf(user1Address);
//     uint balance2After = erc20.balanceOf(user2Address);
//     uint balance3After = erc20.balanceOf(user3Address);
//
//     // Then
//     assertTrue(transfer1SuccessStatus);
//     assertTrue(transfer2SuccessStatus);
//     assertEq(balance1Before - balance1After, transferAmount1 + transferAmount2);
//     assertEq(balance2After - balance2Before, transferAmount2);
//     assertEq(balance3After - balance3Before, transferAmount1);
//   }
// }
//
