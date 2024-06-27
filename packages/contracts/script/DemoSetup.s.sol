// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import { Script } from "forge-std/Script.sol";

import { console } from "forge-std/console.sol";

import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { IWorld } from "@interface/IWorld.sol";

import { IERC20Mintable } from "@latticexyz/world-modules/src/modules/erc20-puppet/IERC20Mintable.sol";

import { CSVectorsTable, CSVectorsTableData, CSVectorPotentialsLookupTable, CSVectorPotentialsLookupTable, CSForcesTable, CSForcesTableData, CSMotionsTable, CSMotionsTableData, CSMotionForcesLookupTable, CSMotionForcesLookupTable, CSVectorPotentialsLookupTable, CSPotentialsTable, CSPotentialsTableData, CSSystemTokenTable, CSSystemTokenTableData } from "@storage/index.sol";

import { VectorStatus, MotionStatus, ForceDirection } from "@storage/common.sol";
import { ScriptWithSetup } from "@utils/Setup.sol";

import { BytesUtils, StringUtils } from "@utils/index.sol";

import { TOKEN_SYMBOL } from "@constants/globals.sol";

contract DemoSetup is ScriptWithSetup {
  using BytesUtils for bytes32;
  using StringUtils for string;

  function run(address worldAddress) external {
    //
  }
}
