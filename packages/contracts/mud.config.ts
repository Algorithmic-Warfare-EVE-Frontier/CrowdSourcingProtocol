import { defineWorld } from "@latticexyz/world";

export default defineWorld({
  enums: {
    ProjectStatus: ["CROWDING", "INPROGRESS", "ARCHIVED"],
    RequestStatus: ["ACTIVE", "CANCELLED", "CLAIMED"],
    ApprovalStatus: ["REJECTED", "ACCEPTED", "PENDING"],
    Vote: ["APPROVED", "DECLINED"],
  },
  namespace: "app",
  tables: {
    ProjectsMetadataTable: {
      key: ["projectId"],
      schema: {
        projectId: "bytes32",
        timestamp: "uint32",
        threshold: "uint256",
        target: "uint256",
        deadline: "uint32",
        manager: "address",
      },
    },
    ProjectsDataTable: {
      key: ["projectId"],
      schema: {
        projectId: "bytes32",
        balance: "uint256",
        rejections: "uint32",
        projectStatus: "ProjectStatus",
        description: "string",
        title: "string",
      },
    },
    ContributersTable: {
      key: ["projectId", "contributer"],
      schema: {
        projectId: "bytes32",
        contributer: "address",
        amount: "uint256",
        votingPower: "uint32",
      },
    },
    RequestsMetadataTable: {
      key: ["requestId"],
      schema: {
        requestId: "bytes32",
        projectId: "bytes32",
        timestamp: "uint32",
        recepient: "address",
        amount: "uint256",
        title: "string",
      },
    },
    RequestsDataTable: {
      key: ["requestId"],
      schema: {
        requestId: "bytes32",
        approvalRate: "uint32",
        denialRate: "uint32",
        requestStatus: "RequestStatus",
        approvalStatus: "ApprovalStatus",
        description: "string",
      },
    },
    VotesTable: {
      key: ["voteId"],
      schema: {
        voteId: "bytes32",
        requestId: "bytes32",
        timestamp: "uint32",
        contributer: "address",
        vote: "Vote",
        note: "string",
      },
    },
  },
});
