// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

/**
 * @title ITasksSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface ITasksSystem {
  function csp__addTask(string memory description) external returns (bytes32 id);

  function csp__completeTask(bytes32 id) external;

  function csp__resetTask(bytes32 id) external;

  function csp__deleteTask(bytes32 id) external;
}
