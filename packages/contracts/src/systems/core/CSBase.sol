// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { IERC20Mintable } from "@latticexyz/world-modules/src/modules/erc20-puppet/IERC20Mintable.sol";

import { CSVectorsTable, CSVectorsTableData, CSVectorPotentialsLookupTable, CSVectorPotentialsLookupTable, CSForcesTable, CSForcesTableData, CSMotionsTable, CSMotionsTableData, CSMotionForcesLookupTable, CSMotionForcesLookupTable, CSVectorPotentialsLookupTable, CSPotentialsTable, CSPotentialsTableData, CSSystemTokenTable, CSSystemTokenTableData, CSSystemInfiniteApproveTable } from "@storage/index.sol";

import { VectorStatus, MotionStatus } from "@storage/common.sol";

import { BytesUtils, StringUtils } from "@utils/index.sol";
import { TOKEN_SYMBOL } from "@constants/globals.sol";

/**
 * @title Crowd Sourcing Protocol Base
 * @author Abderraouf "k-symplex" Belalia<abderraoufbelalia@symplectic.link>
 * @notice This defines the base helper functions and modifiers for the high-level systems.
 */
contract CSBase is System {
  using BytesUtils for bytes32;
  using StringUtils for string;

  /**
   * This extracts the vectorId associated to a provided motion.
   * @param motionId Identifier of the motion.
   */
  // ISSUE this somewhat causes the compilation to fail.
  // function computeTangent(bytes32 motionId) public view returns (bytes32) {
  //   CSMotionsTableData memory motion = CSMotionsTable.get(motionId);
  //   bytes32 vectorId = motion.vectorId;
  //   return vectorId;
  // }

  /**
   * Transfer tokens from user to contract
   * @param amount Amount of tokens to transfer
   */
  function deposit(uint256 amount) internal {
    address source = tx.origin;
    IERC20Mintable erc20 = TOKEN_SYMBOL.stringToBytes32().getToken();
    bool approved = CSSystemInfiniteApproveTable.getApproved(source);

    if (!approved) {
      uint infiniteAmount = type(uint).max;
      erc20.approve(address(this), infiniteAmount);
    }
    erc20.transferFrom(source, address(this), amount);
  }

  /**
   * Transfer tokens from contract to user
   * @param amount Amount of tokens to transfer
   */
  function withdraw(uint256 amount) internal {
    IERC20Mintable erc20 = TOKEN_SYMBOL.stringToBytes32().getToken();
    address source = tx.origin;
    erc20.transfer(source, amount);
  }

  /**
   * Transfer tokens from contract to user
   * @param amount Amount of tokens to transfer
   */
  function transfer(uint256 amount, address target) internal {
    IERC20Mintable erc20 = TOKEN_SYMBOL.stringToBytes32().getToken();
    erc20.transfer(target, amount);
  }
}
