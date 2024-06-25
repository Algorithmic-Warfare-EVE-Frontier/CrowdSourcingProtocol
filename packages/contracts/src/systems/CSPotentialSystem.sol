// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IERC20Mintable } from "@latticexyz/world-modules/src/modules/erc20-puppet/IERC20Mintable.sol";

import { CSSystem } from "@systems/core/CSSystem.sol";
import { CSVectorsTable, CSVectorsTableData, CSPotentialsTable, CSPotentialsTableData, CSVectorPotentialsLookupTable, CSVectorPotentialsLookupTable, CSSystemInfiniteApproveTable } from "../codegen/index.sol";
import { VectorStatus } from "../codegen/common.sol";
import { AddressUtils } from "@utils/index.sol";

import { BytesUtils, StringUtils } from "@utils/index.sol";
import { TOKEN_SYMBOL } from "@constants/globals.sol";

/**
 * @title Crowd Sourcing Protocol - Potential System
 * @author Abderraouf "k-symplex" Belalia<abderraoufbelalia@symplectic.link>
 * @notice This system defines the main API of potential handling.
 */
contract CSPotentialSystem is CSSystem {
  /**
   * Toggle on/off infinite approve.
   */
  function toggleInfiniteApprove() public returns (address) {
    address source = tx.origin;
    uint infiniteAmount = type(uint).max;
    uint zeroAmount = type(uint).min;
    bool approved = CSSystemInfiniteApproveTable.getApproved(source);
    if (approved) {
      CSSystemInfiniteApproveTable.setApproved(source, false);
      return grantApproval(zeroAmount);
    } else {
      CSSystemInfiniteApproveTable.setApproved(source, true);
      return grantApproval(infiniteAmount);
    }
  }

  /**
   * Grant an allowance from a user to this contract
   * @param amount Amount of money to allow this contract to spend
   */
  function grantApproval(uint amount) public returns (address) {
    IERC20Mintable erc20 = BytesUtils.getToken(TOKEN_SYMBOL);
    bool status = erc20.approve(address(this), amount * 1 ether);

    if (status) {
      return address(this);
    } else {
      revert("Approval failed.");
    }
  }

  /**
   * Create a "delta" contribution.
   * @param vectorId Identifier of the vector.
   * @param strength Amount of tokens to contribute with.
   *
   * @notice Here a "delta" means a difference of potential, because the fact that you contributed to a given a vector and not another amounts to a polarization in the landscape of ideas.
   */
  function storeEnergy(
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

    IERC20Mintable erc20 = BytesUtils.getToken(TOKEN_SYMBOL);
    erc20.transferFrom(source, address(this), strength * 1 ether);

    bytes32 potentialId = keccak256(abi.encodePacked(block.timestamp, block.prevrandao));

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
  function releaseEnergy(bytes32 vectorId) public payable onlyArchived(vectorId) onlyPotential(vectorId) {
    address source = tx.origin;

    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);

    bytes32 potentialId = AddressUtils.getPotentialId(source, vectorId);
    CSPotentialsTableData memory potential = CSPotentialsTable.get(potentialId);

    IERC20Mintable erc20 = BytesUtils.getToken(TOKEN_SYMBOL);
    erc20.transfer(source, potential.strength * 1 ether);

    // TODO We need to remove the user from the list of potentials.
    CSVectorsTable.setCharge(vectorId, vector.charge - potential.strength);
  }
}
