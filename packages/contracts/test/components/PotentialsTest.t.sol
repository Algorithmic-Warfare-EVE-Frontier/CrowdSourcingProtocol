// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { MudTest } from "@latticexyz/world/test/MudTest.t.sol";
import { IERC20Mintable } from "@latticexyz/world-modules/src/modules/erc20-puppet/IERC20Mintable.sol";

import { IWorld } from "../../src/codegen/world/IWorld.sol";
import { CSVectorsTable, CSVectorsTableData, CSPotentialsTable, CSPotentialsTableData, CSVectorPotentialsLookupTable } from "../../src/codegen/index.sol";
import { VectorStatus } from "../../src/codegen/common.sol";
import { TestWithSetup } from "@utils/Setup.sol";

import { BytesUtils, StringUtils } from "@utils/index.sol";
import { TOKEN_SYMBOL } from "@constants/globals.sol";

contract PotentialTest is TestWithSetup {
  /**
   * Case: User stores "energy" token (symbol: PATKN) in the contract.
   */
  function testStoreEnergy() public {
    // -------------------------------------

    // Given
    bytes32 vectorId = prepareVectorInitiatedBy(user1PrivateKey, 300000 * 1 ether, 5 days, "This is a test");

    // When
    // - User 2 approves the transfer.
    vm.startPrank(user2Address);
    address contractAddress = IWorld(worldAddress).csp__grantApproval(200);
    vm.stopPrank();

    // Debug
    IERC20Mintable erc20 = BytesUtils.getToken(TOKEN_SYMBOL);
    uint balance = erc20.balanceOf(user2Address);
    console.log(user2Address, balance);
    uint allowance = erc20.allowance(user2Address, contractAddress);
    console.log(contractAddress, allowance);

    // - User 2 asks the contract to transfer itself the approved amount.
    vm.startPrank(user2Address);
    bytes32 potentialId = IWorld(worldAddress).csp__storeEnergy(vectorId, 200);
    vm.stopPrank();

    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    CSPotentialsTableData memory potential = CSPotentialsTable.get(potentialId);
    bytes32[] memory potentialIds = CSVectorPotentialsLookupTable.get(vectorId);

    // Then
    assertEq(potential.source, user2Address);
    assertEq(potential.strength, 10000);
    assertEq(vector.charge, 10000);
    assertEq(potential.vectorId, vectorId);
    assertEq(potentialIds[0], potentialId);
    // -------------------------------------
  }

  function testReleaseEnergy() public {
    // -------------------------------------
    // Given
    // bytes32 vectorId = prepareVectorInitiatedBy(user1Address, 30000);
    // CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    // uint amount = 10000;
    // // When
    // vm.startPrank(user2Address);
    // IWorld(worldAddress).csp__storeEnergy(vectorId, amount);
    // vm.stopPrank();
    // // Then
    // assertEq(vector.charge, amount);
    // // When
    // vm.startPrank(user1Address);
    // IWorld(worldAddress).csp__archiveVector(vectorId);
    // vm.stopBroadcast();
    // // Then
    // assertTrue(vector.status == VectorStatus.ARCHIVED);
    // // When
    // vm.startBroadcast(user2Address);
    // IWorld(worldAddress).csp__releaseEnergy(vectorId);
    // vm.stopBroadcast();
    // // Then
    // assertEq(vector.charge, 0);
    // -------------------------------------
  }
}
