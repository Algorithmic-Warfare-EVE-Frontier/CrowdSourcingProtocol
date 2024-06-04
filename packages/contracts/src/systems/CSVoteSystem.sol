// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { ProjectsDataTable, ProjectsDataTableData, ProjectsMetadataTable, ProjectsMetadataTableData, ContributersTable, RequestsDataTable, RequestsDataTableData, RequestsMetadataTable, RequestsMetadataTableData, VotesTable, VotesTableData } from "../codegen/index.sol";
import { ProjectStatus, RequestStatus, ApprovalStatus, Vote } from "../codegen/common.sol";

contract CSVoteSystem is System {
  // Scopes the function to the manager only.
  modifier manager(bytes32 projectId) {
    address manager = ProjectsMetadataTable.getManager(projectId);
    require(_msgSender() == manager);

    _;
  }

  // Gets the projectId associated to a requestId.
  function projectIdFromRequestId(bytes32 requestId) internal returns (bytes32) {
    bytes32 projectId = RequestsMetadataTable.getProjectId(requestId);
    return projectId;
  }

  // Make sure a request is active.
  modifier active(bytes32 requestId) {
    RequestStatus requestStatus = RequestsDataTable.getRequestStatus(requestId);
    require(requestStatus == RequestStatus.ACTIVE);

    _;
  }

  /**
   * Approves a request.
   * @param requestId Identifier of the request.
   * @param note Optional comment to go with the vote.
   */
  function approve(
    bytes32 requestId,
    string memory note
  ) public manager(projectIdFromRequestId(requestId)) active(requestId) {
    uint32 timestamp = uint32(block.timestamp);
    address contributor = _msgSender();

    bytes32 projectId = RequestsMetadataTable.getProjectId(requestId);
    uint32 votingPower = ContributersTable.getVotingPower(projectId, contributor);
    uint32 approvalRate = RequestsDataTable.getApprovalRate(requestId) + votingPower;

    bytes32 voteId = keccak256(abi.encode(timestamp));

    VotesTable.set(
      voteId,
      VotesTableData({
        requestId: requestId,
        timestamp: timestamp,
        contributer: contributor,
        vote: Vote.APPROVED,
        note: note
      })
    );

    RequestsDataTable.setApprovalRate(requestId, approvalRate);

    if (approvalRate > 50) {
      RequestsDataTable.setApprovalStatus(requestId, ApprovalStatus.ACCEPTED);
    }
  }

  /**
   * Declines a request.
   * @param requestId Identifier of the request.
   * @param note Required comment to go with the vote.
   */
  function decline(
    bytes32 requestId,
    string memory note
  ) public manager(projectIdFromRequestId(requestId)) active(requestId) {
    address contributor = _msgSender();
    uint32 timestamp = uint32(block.timestamp);

    bytes32 projectId = RequestsMetadataTable.getProjectId(requestId);
    uint32 votingPower = ContributersTable.getVotingPower(projectId, contributor);
    uint32 denialRate = RequestsDataTable.getDenialRate(requestId) + votingPower;
    uint32 rejections = ProjectsDataTable.getRejections(projectId);

    bytes32 voteId = keccak256(abi.encode(timestamp));

    VotesTable.set(
      voteId,
      VotesTableData({
        requestId: requestId,
        timestamp: timestamp,
        contributer: contributor,
        vote: Vote.DECLINED,
        note: note
      })
    );

    RequestsDataTable.setDenialRate(requestId, denialRate);

    if (denialRate > 50) {
      RequestsDataTable.setApprovalStatus(requestId, ApprovalStatus.REJECTED);
      ProjectsDataTable.setRejections(projectId, rejections++);

      if (rejections++ >= 3) {
        ProjectsDataTable.setProjectStatus(projectId, ProjectStatus.ARCHIVED);
      }
    }
  }
}
