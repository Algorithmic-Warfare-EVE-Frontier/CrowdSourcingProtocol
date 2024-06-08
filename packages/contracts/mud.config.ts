import { defineWorld } from "@latticexyz/world";

export default defineWorld({
  namespace: "csp",
  tables: {
    // Projects
    CSProjectsMetadataTable: {
      schema: {
        id: "bytes32",
        createdAt: "uint256",
        modifiedAt: "uint256",
      },
      key: ["id"],
    },
    CSProjectsDataTable: {
      schema: {
        id: "bytes32",
        threshold: "uint256",
        target: "uint256",
        deadline: "uint32",
        symbol: "bytes32",
        codename: "bytes32",
        title: "string",
        description: "string",
      },
      key: ["id"],
    },
  },
});
