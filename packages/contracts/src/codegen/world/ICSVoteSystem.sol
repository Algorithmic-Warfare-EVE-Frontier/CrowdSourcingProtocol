// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

/**
 * @title ICSVoteSystem
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface ICSVoteSystem {
  function csp__approve(bytes32 requestId, string memory note) external;

  function csp__decline(bytes32 requestId, string memory note) external;
}
