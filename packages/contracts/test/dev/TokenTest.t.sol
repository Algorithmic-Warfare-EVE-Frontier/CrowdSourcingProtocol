// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { MudTest } from "@latticexyz/world/test/MudTest.t.sol";

import { IWorld } from "@interface/IWorld.sol";
import { IERC20Mintable } from "@latticexyz/world-modules/src/modules/erc20-puppet/IERC20Mintable.sol";

import { BytesUtils, StringUtils } from "@utils/index.sol";

import { TOKEN_SYMBOL } from "@constants/globals.sol";

import { TestWithSetup } from "@utils/Setup.sol";

// This has been used in development to check the token work.

contract TokenTest is TestWithSetup {
  using BytesUtils for bytes32;
  using StringUtils for string;

  function testTokenExists() public {
    // Given
    string memory tokenSymbol = "PATKN";

    // When
    IERC20Mintable erc20 = tokenSymbol.stringToBytes32().getToken();

    // Then
    assertEq("PA Token", erc20.name());
    assertEq("PATKN", erc20.symbol());
  }

  function testDefaultAccountsHaveAllowance() public {
    // Given
    string memory tokenSymbol = "PATKN";
    IERC20Mintable erc20 = tokenSymbol.stringToBytes32().getToken();

    // When
    uint totalSupply = erc20.totalSupply();

    // Then
    assertEq(totalSupply, 9 * 10000000000 * 1 ether);
  }

  function testDefaultAccountsCanTransfer() public {
    // Given
    string memory tokenSymbol = "PATKN";
    IERC20Mintable erc20 = tokenSymbol.stringToBytes32().getToken();

    uint amount = 10000 * 1 ether;

    uint balance1Before = erc20.balanceOf(user1Address);
    uint balance2Before = erc20.balanceOf(user2Address);

    // When
    vm.prank(user1Address);
    bool successStatus = erc20.transfer(user2Address, amount);

    uint balance1After = erc20.balanceOf(user1Address);
    uint balance2After = erc20.balanceOf(user2Address);

    // Then
    assertTrue(successStatus);
    assertEq(balance1Before - balance1After, amount);
    assertEq(balance2After - balance2Before, amount);
  }

  function testCanInfiniteApprove() public {
    // Given
    string memory tokenSymbol = "PATKN";
    IERC20Mintable erc20 = tokenSymbol.stringToBytes32().getToken();

    uint infiniteAmount = type(uint).max;

    // When
    vm.prank(user1Address);
    bool successStatus = erc20.approve(user2Address, infiniteAmount);
    uint allowance = erc20.allowance(user1Address, user2Address);

    // Then
    assertTrue(successStatus);
    assertEq(allowance, infiniteAmount);
  }

  function testCanTransferFrom() public {
    // Given
    string memory tokenSymbol = "PATKN";
    IERC20Mintable erc20 = tokenSymbol.stringToBytes32().getToken();

    uint infiniteAmount = type(uint).max;
    vm.startPrank(user1Address);
    erc20.approve(user2Address, infiniteAmount);
    vm.stopPrank();

    uint transferAmount1 = 12 * 1 ether;
    uint transferAmount2 = 98 * 1 ether;

    uint balance1Before = erc20.balanceOf(user1Address);
    uint balance2Before = erc20.balanceOf(user2Address);
    uint balance3Before = erc20.balanceOf(user3Address);

    // When
    vm.startPrank(user2Address);
    bool transfer1SuccessStatus = erc20.transferFrom(user1Address, user3Address, transferAmount1);
    bool transfer2SuccessStatus = erc20.transferFrom(user1Address, user2Address, transferAmount2);
    vm.stopPrank();

    uint balance1After = erc20.balanceOf(user1Address);
    uint balance2After = erc20.balanceOf(user2Address);
    uint balance3After = erc20.balanceOf(user3Address);

    // Then
    assertTrue(transfer1SuccessStatus);
    assertTrue(transfer2SuccessStatus);
    assertEq(balance1Before - balance1After, transferAmount1 + transferAmount2);
    assertEq(balance2After - balance2Before, transferAmount2);
    assertEq(balance3After - balance3Before, transferAmount1);
  }
}
