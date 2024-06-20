import { mudConfig } from "@latticexyz/world/register";

export default mudConfig({
  enums: {
    VectorStatus: ["CHANNELING", "DISCHARGING", "ARCHIVED"],
    MotionStatus: ["PENDING", "PROCEEDING", "HALTING", "CANCELLED"],
    ForceDirection: ["ALONG", "AGAINST"],
  },
  namespace: "csp",
  tables: {
    CSSystemTokenTable: {
      keySchema: {
        tokenSymbol: "bytes32",
      },
      valueSchema: {
        tokenAddress: "address",
        tokenName: "string",
      },
    },
    // Projects
    CSVectorsTable: {
      valueSchema: {
        handler: "address",
        charge: "uint256",
        capacity: "uint256",
        lifetime: "uint256",
        status: "VectorStatus",
        insight: "string",
      },
      keySchema: {
        id: "bytes32",
      },
    },
    CSVectorMotionsLookupTable: {
      valueSchema: {
        motionIds: "bytes32[]",
      },
      keySchema: {
        vectorId: "bytes32",
      },
    },
    CSMotionsTable: {
      valueSchema: {
        vectorId: "bytes32",
        target: "address",
        momentum: "uint256",
        push: "uint256",
        pull: "uint256",
        lifetime: "uint256",
        status: "MotionStatus",
        insight: "string",
      },
      keySchema: {
        id: "bytes32",
      },
    },
    CSMotionForcesLookupTable: {
      valueSchema: {
        forceIds: "bytes32[]",
      },
      keySchema: {
        motionId: "bytes32",
      },
    },
    CSForcesTable: {
      valueSchema: {
        motionId: "bytes32",
        potentialId: "bytes32",
        power: "uint256",
        direction: "ForceDirection",
        insight: "string",
      },
      keySchema: {
        id: "bytes32",
      },
    },
    CSPotentialsTable: {
      valueSchema: {
        vectorId: "bytes32",
        source: "address",
        strength: "uint256",
      },
      keySchema: {
        id: "bytes32",
      },
    },
    CSVectorPotentialsLookupTable: {
      valueSchema: {
        potentialIds: "bytes32[]",
      },
      keySchema: {
        vectorId: "bytes32",
      },
    },
  },
});
