import { defineWorld } from "@latticexyz/world";

export default defineWorld({
  enums: {
    VectorStatus: ["CHANNELING", "DISCHARGING", "ARCHIVED"],
    MotionStatus: ["PENDING", "PROCEEDING", "HALTING", "CANCELLED"],
    ForceDirection: ["ALONG", "AGAINST"],
  },
  namespace: "csp",
  tables: {
    // Projects
    CSVectorsTable: {
      schema: {
        id: "bytes32",
        handler: "address",
        charge: "uint256",
        capacity: "uint256",
        lifetime: "uint256",
        status: "VectorStatus",
        insight: "string",
      },
      key: ["id"],
    },
    CSVectorMotionsLookupTable: {
      schema: {
        vectorId: "bytes32",
        motionIds: "bytes32[]",
      },
      key: ["vectorId"],
    },
    CSMotionsTable: {
      schema: {
        id: "bytes32",
        vectorId: "bytes32",
        target: "address",
        momentum: "uint256",
        push: "uint256",
        pull: "uint256",
        lifetime: "uint256",
        status: "MotionStatus",
        insight: "string"
      },
      key: ["id"],
    },
    CSMotionForcesLookupTable: {
      schema: {
        motionId: "bytes32",
        forceIds: "bytes32[]",
      },
      key: ["motionId"],
    },
    CSForcesTable: {
      schema: {
        id: "bytes32",
        motionId: "bytes32",
        potentialId: "bytes32",
        power: "uint256",
        direction: "ForceDirection",
        insight: "string",
      },
      key: ["id"],
    },
    CSPotentialsTable: {
      schema: {
        id: "bytes32",
        vectorId: "bytes32",
        source: "address",
        strength: "uint256",
      },
      key: ["id"],
    },
    CSVectorPotentialsLookupTable: {
      schema: {
        vectorId: "bytes32",
        potentialIds: "bytes32[]",
      },
      key: ["vectorId"],
    },
  },
});
