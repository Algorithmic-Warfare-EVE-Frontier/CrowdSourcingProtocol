// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { ProjectsMetadataTable, RequestsDataTable, RequestsDataTableData, RequestsMetadataTable, RequestsMetadataTableData } from "../codegen/index.sol";
import { RequestStatus, ApprovalStatus } from "../codegen/common.sol";

contract CSRequestSystem is System {
  // Scopes the function to the manager only.
  modifier onlyManager(bytes32 projectId) {
    address manager = ProjectsMetadataTable.getManager(projectId);
    require(_msgSender() == manager);

    _;
  }

  // Gets the projectId associated to a requestId.
  function projectIdFromRequestId(bytes32 requestId) internal view returns (bytes32) {
    bytes32 projectId = RequestsMetadataTable.getProjectId(requestId);
    return projectId;
  }

  // Makes sure a request is has been approved.
  modifier approved(bytes32 requestId) {
    ApprovalStatus approvalStatus = RequestsDataTable.getApprovalStatus(requestId);
    require(approvalStatus == ApprovalStatus.ACCEPTED);

    _;
  }

  /**
   * Cancels the request.
   * Note: Can only be done by the manager.
   * @param requestId Identifier for the request.
   */
  function cancel(bytes32 requestId) public onlyManager(projectIdFromRequestId(requestId)) {
    RequestsDataTable.setRequestStatus(requestId, RequestStatus.CANCELLED);
  }

  /**
   * Proceeds with an approved request.
   * @param requestId Identifier for the request.
   */
  function proceed(bytes32 requestId) public onlyManager(projectIdFromRequestId(requestId)) approved(requestId) {
    address contributor = _msgSender();
    uint256 amount = RequestsMetadataTable.getAmount(requestId);

    payable(contributor).transfer(amount);

    RequestsDataTable.setRequestStatus(requestId, RequestStatus.CLAIMED);
  }
}
