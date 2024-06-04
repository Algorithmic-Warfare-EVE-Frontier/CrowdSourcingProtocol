// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { MudTest } from "@latticexyz/world/test/MudTest.t.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";
import { ProjectsMetadataTable, ProjectsMetadataTableData, ContributersTable, ContributersTableData } from "../src/codegen/index.sol";

contract ProjectsTest is MudTest {
  function testWorldExists() public {
    uint256 codeSize;
    address addr = worldAddress;
    assembly {
      codeSize := extcodesize(addr)
    }
    assertTrue(codeSize > 0);
  }

  function testCreateProject() public {
    bytes32 projectId = keccak256(abi.encode("Sample Project"));

    ProjectsMetadataTableData memory project = ProjectsMetadataTable.get(projectId);

    assertEq(project.target, 100);
    assertEq(project.threshold, 10);
  }

  function testDidContribute() public {
    uint256 user2PrivateKey = vm.envUint("PRIVATE_KEY_2");
    address user2 = vm.addr(user2PrivateKey);

    bytes32 projectId = keccak256(abi.encode("Sample Project"));

    ContributersTableData memory contribution = ContributersTable.get(projectId, user2);

    console.log(contribution.amount);
    assertEq(projectId, projectId);
  }
}
