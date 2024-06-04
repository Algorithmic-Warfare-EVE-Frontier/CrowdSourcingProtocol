// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { ProjectsDataTable, ProjectsDataTableData, ProjectsMetadataTable, ProjectsMetadataTableData, ContributersTable, RequestsDataTable, RequestsDataTableData, RequestsMetadataTable, RequestsMetadataTableData } from "../codegen/index.sol";
import { ProjectStatus, RequestStatus, ApprovalStatus } from "../codegen/common.sol";

contract CSProjectSystem is System {
  // Scopes the function to the manager only.
  modifier manager(bytes32 projectId) {
    address manager = ProjectsMetadataTable.getManager(projectId);
    require(_msgSender() == manager);

    _;
  }

  // Scopes the function to non-manager users.
  modifier notManager(bytes32 projectId) {
    address manager = ProjectsMetadataTable.getManager(projectId);
    require(_msgSender() != manager);

    _;
  }

  // Verifies that the project hasn't expired.
  modifier notExpired(bytes32 projectId) {
    uint32 deadline = ProjectsMetadataTable.getDeadline(projectId);
    require(block.timestamp < deadline);

    _;
  }

  // Verifies that the project has expired.
  modifier expired(bytes32 projectId) {
    uint32 deadline = ProjectsMetadataTable.getDeadline(projectId);
    require(block.timestamp > deadline);

    ProjectsDataTable.setProjectStatus(projectId, ProjectStatus.ARCHIVED);

    _;
  }

  // Makes sure that the project is archived by the manager.
  modifier archived(bytes32 projectId) {
    uint32 deadline = ProjectsMetadataTable.getDeadline(projectId);
    ProjectStatus projectStatus = ProjectsDataTable.getProjectStatus(projectId);

    require(projectStatus == ProjectStatus.ARCHIVED);

    _;
  }

  // Makes sure that the project is not archived by the manager.
  modifier notArchived(bytes32 projectId) {
    ProjectStatus projectStatus = ProjectsDataTable.getProjectStatus(projectId);

    require(projectStatus != ProjectStatus.ARCHIVED);

    _;
  }

  // Makes sure the project is either archived or expired.
  modifier eitherArchivedOrExpired(bytes32 projectId) {
    uint32 deadline = ProjectsMetadataTable.getDeadline(projectId);
    ProjectStatus projectStatus = ProjectsDataTable.getProjectStatus(projectId);
    require(block.timestamp > deadline || projectStatus != ProjectStatus.ARCHIVED);

    _;
  }

  /**
   * Create a crowd sourcing project.
   * @param threshold Minimum amount for contributions.
   * @param target Target amount for this project.
   * @param title Title of the project.
   * @param description Description of the project.
   * @param optout Option for contribution opt-out.
   */
  function create(
    uint32 threshold,
    uint32 target,
    uint32 deadline,
    string memory title,
    string memory description,
    bool optout
  ) public {
    address manager = _msgSender();
    uint32 timestamp = uint32(block.timestamp);

    bytes32 projectId = keccak256(abi.encode(title));

    ProjectsMetadataTable.set(
      projectId,
      ProjectsMetadataTableData({
        threshold: threshold,
        target: target,
        deadline: deadline,
        timestamp: timestamp,
        manager: manager
      })
    );

    ProjectsDataTable.set(
      projectId,
      ProjectsDataTableData({
        balance: 0,
        rejections: 0,
        description: description,
        title: title,
        projectStatus: ProjectStatus.CROWDING
      })
    );
  }

  /**
   * Archives an on-going project.
   * @param projectId Identifier of the project.
   */
  function archive(bytes32 projectId) public manager(projectId) {
    ProjectsDataTable.setProjectStatus(projectId, ProjectStatus.ARCHIVED);
  }

  /**
   * Claims the shares of a contributor after a project has expired or been archived.
   * @param projectId Identifier of the project.
   */
  function claim(bytes32 projectId) public notManager(projectId) eitherArchivedOrExpired(projectId) {
    address contributor = _msgSender();
    uint256 balance = ProjectsMetadataTable.getThreshold(projectId);
    uint32 votingPower = ContributersTable.getVotingPower(projectId, contributor);

    uint256 amount = uint256((balance * votingPower) / 100);

    payable(contributor).transfer(amount);
  }

  /**
   * Registers a contribution in the a project.
   * Note: A player can only contribute once.
   * TODO: Allow multiple contributions.
   * @param projectId Identifier of the project.
   */
  function contribute(
    bytes32 projectId
  ) public payable notManager(projectId) notExpired(projectId) notArchived(projectId) {
    uint256 amount = _msgValue();
    address contributor = _msgSender();

    uint256 target = ProjectsMetadataTable.getTarget(projectId);
    uint256 threshold = ProjectsMetadataTable.getThreshold(projectId);
    uint256 balance = ProjectsMetadataTable.getThreshold(projectId);

    uint256 contribution = ContributersTable.getAmount(projectId, _msgSender());

    // Make sure the player didn't contribute before.
    require(contribution == 0);

    // Makre sure the amount is above the threshold for this project.
    require(_msgValue() >= threshold);

    // Makes sure the contribution doesn't exceed the target.
    require(amount + balance <= target);

    // Compute the contribution data.
    uint32 votingPower = uint32(amount / target) * 100;

    ContributersTable.set(projectId, contributor, amount, votingPower);
    ProjectsDataTable.setBalance(projectId, amount + balance);

    if (amount + balance == target) {
      ProjectsDataTable.setProjectStatus(projectId, ProjectStatus.INPROGRESS);
    }
  }

  /**
   * Creates a request to use a part of the crowdsourced capital.
   * Note: Only the manager issues this type of requests.
   * @param projectId Identifier of the project.
   * @param recepient Recepient of the requested amount.
   * @param amount Requested amount to pull.
   * @param title Title of the requests.
   * @param description Description of the request.
   */
  function request(
    bytes32 projectId,
    address recepient,
    uint256 amount,
    string memory title,
    string memory description
  ) public manager(projectId) notExpired(projectId) notArchived(projectId) {
    uint32 timestamp = uint32(block.timestamp);
    bytes32 requestId = keccak256(abi.encode(title));

    RequestsMetadataTable.set(
      requestId,
      RequestsMetadataTableData({
        projectId: projectId,
        timestamp: timestamp,
        recepient: recepient,
        amount: amount,
        title: title
      })
    );

    RequestsDataTable.set(
      requestId,
      RequestsDataTableData({
        requestStatus: RequestStatus.ACTIVE,
        approvalStatus: ApprovalStatus.PENDING,
        approvalRate: 0,
        denialRate: 0,
        description: description
      })
    );
  }
}
