// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IERC20Mintable } from "@latticexyz/world-modules/src/modules/erc20-puppet/IERC20Mintable.sol";
import { CSSystemTokenTable, CSSystemTokenTableData } from "../codegen/index.sol";

library TokenSymbolUtils {
  /**
   * Recover token based on its symbol
   * @param self Symbol associated to the token
   */
  function getToken(bytes32 self) public view returns (IERC20Mintable) {
    CSSystemTokenTableData memory patkn = CSSystemTokenTable.get(self);
    address erc20Address = patkn.tokenAddress;
    IERC20Mintable erc20 = IERC20Mintable(erc20Address);
    return erc20;
  }
}
