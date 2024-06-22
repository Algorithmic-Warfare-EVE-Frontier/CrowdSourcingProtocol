// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IERC20Mintable } from "@latticexyz/world-modules/src/modules/erc20-puppet/IERC20Mintable.sol";
import { CSSystemTokenTable, CSSystemTokenTableData } from "@storage/index.sol";

library BytesUtils {
  /**
   * Recover token based on its symbol
   * @param self Symbol associated to the token
   */
  function getToken(bytes32 self) internal view returns (IERC20Mintable) {
    address tokenAddress = CSSystemTokenTable.getTokenAddress(self);
    if (tokenAddress != 0x0000000000000000000000000000000000000000) {
      IERC20Mintable erc20 = IERC20Mintable(tokenAddress);
      return erc20;
    } else {
      revert("Token does not exist");
    }
  }
}
