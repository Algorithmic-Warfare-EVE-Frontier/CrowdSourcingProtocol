import { mudConfig } from "@latticexyz/world/register";

export default mudConfig({
  enums: {
    ProjectStatus: ["CROWDING", "INPROGRESS", "ARCHIVED"],
    RequestStatus: ["ACTIVE", "CANCELLED", "CLAIMED"],
    ApprovalStatus: ["REJECTED", "ACCEPTED", "PENDING"],
    Vote: ["APPROVED", "DECLINED"],
  },
  namespace: "app",
  tables: {
    ProjectsMetadataTable: {
      keySchema: {
        projectId: "bytes32",
      },
      valueSchema: {
        timestamp: "uint32",
        threshold: "uint256",
        target: "uint256",
        deadline: "uint32",
        manager: "address",
      },
    },
    ProjectsDataTable: {
      keySchema: {
        projectId: "bytes32",
      },
      valueSchema: {
        balance: "uint256",
        rejections: "uint32",
        projectStatus: "ProjectStatus",
        description: "string",
        title: "string",
      },
    },
    ContributersTable: {
      keySchema: {
        projectId: "bytes32",
        contributer: "address",
      },
      valueSchema: {
        amount: "uint256",
        votingPower: "uint32",
      },
    },
    RequestsMetadataTable: {
      keySchema: {
        requestId: "bytes32",
      },
      valueSchema: {
        projectId: "bytes32",
        timestamp: "uint32",
        recepient: "address",
        amount: "uint256",
        title: "string",
      },
    },
    RequestsDataTable: {
      keySchema: {
        requestId: "bytes32",
      },
      valueSchema: {
        approvalRate: "uint32",
        denialRate: "uint32",
        requestStatus: "RequestStatus",
        approvalStatus: "ApprovalStatus",
        description: "string",
      },
    },
    VotesTable: {
      keySchema: {
        requestId: "bytes32",
        contributer: "address",
      },
      valueSchema: {
        timestamp: "uint32",
        vote: "Vote",
        note: "string",
      },
    },
  },
});
