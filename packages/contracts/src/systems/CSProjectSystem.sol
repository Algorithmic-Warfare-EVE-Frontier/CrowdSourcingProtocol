// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { CSProjectsMetadataTable, CSProjectsMetadataTableData, CSProjectsDataTable, CSProjectsDataTableData } from "../codegen/index.sol";

contract CSProjectSystem is System {
  /**
   * Create a crowdsourcing project.
   * @param symbol Unique identifier to serve as symbol for the associated Modded-ERC20 token.
   * @param codename A unique identifier to serve as a short name for the project.
   * @param threshold The minimum amount for a contribution.
   * @param target The target amount for the crowdfunding.
   * @param deadline The time by which the compaign should reach the target.
   * @param title A short description of the project.
   * @param description Long form description with more details
   */
  function createProject(
    bytes32 symbol,
    bytes32 codename,
    uint256 threshold,
    uint256 target,
    uint32 deadline,
    string memory title,
    string memory description
  ) public returns (bytes32) {
    bytes32 projectId = keccak256(abi.encodePacked(symbol, codename));
    uint256 createdAt = block.timestamp;
    uint256 modifiedAt = createdAt;

    CSProjectsMetadataTable.set(
      projectId,
      CSProjectsMetadataTableData({ createdAt: createdAt, modifiedAt: modifiedAt })
    );

    CSProjectsDataTable.set(
      projectId,
      CSProjectsDataTableData({
        symbol: symbol,
        codename: codename,
        threshold: threshold,
        target: target,
        deadline: deadline,
        title: title,
        description: description
      })
    );

    return projectId;
  }
}
