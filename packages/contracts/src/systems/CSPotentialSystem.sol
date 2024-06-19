// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CSSystem } from "./CSSystem.sol";
import { CSVectorsTable, CSVectorsTableData, CSPotentialsTable, CSPotentialsTableData, CSVectorPotentialsLookupTable, CSVectorPotentialsLookupTable } from "../codegen/index.sol";
import { VectorStatus } from "../codegen/common.sol";
import { CSAddressUtils } from "./shared.sol";

/**
 * @title Crowd Sourcing Protocol - Potential System
 * @author Abderraouf "k-symplex" Belalia<abderraoufbelalia@symplectic.link>
 * @notice This system defines the main API of potential handling.
 */
contract CSPotentialSystem is CSSystem {
  using CSAddressUtils for address;

  /**
   * Create a "delta" contribution.
   * @param vectorId Identifier of the vector.
   * @param strength Amount of tokens to contribute with.
   *
   * @notice Here a "delta" means a difference of potential, because the fact that you contributed to a given a vector and not another amounts to a polarization in the landscape of ideas.
   */
  function createDelta(
    bytes32 vectorId,
    uint256 strength
  )
    public
    payable
    notHandler(vectorId)
    withCapacityThreshold(vectorId, strength)
    whenChanneling(vectorId)
    returns (bytes32)
  {
    address source = tx.origin;
    bytes32 potentialId = keccak256(abi.encodePacked(block.timestamp, block.prevrandao));

    erc20.approve(address(this), strength);
    erc20.transferFrom(source, address(this), strength);

    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);

    CSPotentialsTable.set(
      potentialId,
      CSPotentialsTableData({ source: source, strength: strength, vectorId: vectorId })
    );

    CSVectorPotentialsLookupTable.push(vectorId, potentialId);
    CSVectorsTable.setCharge(vectorId, vector.charge + strength);

    if (vector.charge + strength == vector.capacity) {
      CSVectorsTable.setStatus(vectorId, VectorStatus.DISCHARGING);
    }

    return potentialId;
  }

  /**
   * Redeem your contribution.
   * @param vectorId Identifier of the vector.
   *
   * @notice I view this as heat release because the energy you deposited into a vector did not manifest any order based on the vector's insight, instead the vector went bust for some reason and it got archived.
   */
  function releaseHeat(bytes32 vectorId) public payable onlyArchived(vectorId) onlyPotential(vectorId) {
    address source = tx.origin;

    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);

    bytes32 potentialId = source.getPotentialId(vectorId);
    CSPotentialsTableData memory potential = CSPotentialsTable.get(potentialId);

    // erc20.transfer(source, potential.strength);

    // TODO We need to remove the user from the list of potentials.
    CSVectorsTable.setCharge(vectorId, vector.charge - potential.strength);
  }
}
