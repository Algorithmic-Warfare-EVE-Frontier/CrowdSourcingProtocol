// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { IERC20Mintable } from "@latticexyz/world-modules/src/modules/erc20-puppet/IERC20Mintable.sol";

import { console } from "forge-std/console.sol";

import { CSVectorsTable, CSVectorsTableData, CSVectorPotentialsLookupTable, CSVectorPotentialsLookupTable, CSForcesTable, CSForcesTableData, CSMotionsTable, CSMotionsTableData, CSMotionForcesLookupTable, CSMotionForcesLookupTable, CSVectorPotentialsLookupTable, CSPotentialsTable, CSPotentialsTableData, CSSystemTokenTable, CSSystemTokenTableData, CSSystemInfiniteApproveTable, CSVectorMotionsLookupTable } from "@storage/index.sol";

import { VectorStatus, MotionStatus, ForceDirection } from "../codegen/common.sol";

import { AddressUtils, BytesUtils, StringUtils } from "@utils/index.sol";

import { TOKEN_SYMBOL } from "@constants/globals.sol";

/**
 * @title Crowd Sourcing Protocol - Potential System
 * @author Abderraouf "k-symplex" Belalia<abderraoufbelalia@symplectic.link>
 * @notice This system defines the main API of potential handling.
 */
contract CSPSystem is System {
  using BytesUtils for bytes32;
  using StringUtils for string;
  using AddressUtils for address;

  // SECTION - Guards

  /**
   * This makes sure that only the handler of the vector performs an action.
   */
  modifier onlyHandler(bytes32 vectorId) {
    address user = _msgSender();
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    require(user == vector.handler, "Reserved for vector handler only.");
    _;
  }

  /**
   * This makes sure that anyone beside the handler can perform an action.
   */
  modifier notHandler(bytes32 vectorId) {
    address user = _msgSender();
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    require(user != vector.handler, "Reserved for vector handler only.");
    _;
  }

  /**
   * This makes sure that only the handler of the vector performs an action.
   */
  modifier onlyPotential(bytes32 vectorId) {
    address user = tx.origin;
    bytes32 potentialId;
    bool isPotential = false;
    bytes32[] memory potentialIds = CSVectorPotentialsLookupTable.get(vectorId);

    for (uint i = 0; i < potentialIds.length; i++) {
      potentialId = potentialIds[i];
      CSPotentialsTableData memory potential = CSPotentialsTable.get(potentialId);
      isPotential = (user == potential.source);
      if (isPotential) {
        break;
      }
    }

    require(isPotential, "Reserved for vector potentials only.");
    _;
  }

  /**
   * This makes sure that the vector has not been archived.
   */
  modifier notArchived(bytes32 vectorId) {
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    require(vector.status != VectorStatus.ARCHIVED, "Requires vector to not be archived");
    _;
  }

  /**
   * Make sure that the vector has been archived.
   */
  modifier onlyArchived(bytes32 vectorId) {
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    require(vector.status == VectorStatus.ARCHIVED, "Requires vector to be archived.");
    _;
  }

  /**
   * Make sure that the vector is discharging, meaning that it did hit full charge capacity and that the handler is pulling token via motions.
   */
  modifier whenDischarging(bytes32 vectorId) {
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    require(vector.status == VectorStatus.DISCHARGING, "Requires vector to be dicharging.");
    _;
  }

  /**
   * Make sure that the vector is channeling, meaning that it did not hit full charge capacity.
   */
  modifier whenChanneling(bytes32 vectorId) {
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    require(vector.status == VectorStatus.CHANNELING, "Requires vector to be channeling.");
    _;
  }

  /**
   * Makes sure that the potential is not overloading the vector.
   */
  modifier withCapacityThreshold(bytes32 vectorId, uint256 strength) {
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    require(
      strength <= vector.capacity - vector.charge,
      "Requires potential strength to not overload vector capacity."
    );
    _;
  }

  /**
   * Make sure the motion hasn't been cancelled.
   */
  modifier notCancelled(bytes32 motionId) {
    CSMotionsTableData memory motion = CSMotionsTable.get(motionId);
    require(motion.status != MotionStatus.CANCELLED, "Requires motion to not be cancelled.");
    _;
  }

  /**
   * Make sure the motion is in progress.
   */
  modifier onlyPending(bytes32 motionId) {
    CSMotionsTableData memory motion = CSMotionsTable.get(motionId);
    require(motion.status == MotionStatus.PENDING, "Requires motion to be pending.");
    _;
  }

  /**
   * Make sure the motion is proceeding.
   */
  modifier onlyProceeding(bytes32 motionId) {
    CSMotionsTableData memory motion = CSMotionsTable.get(motionId);
    require(motion.status == MotionStatus.PROCEEDING, "Requires motion to be proceeding.");
    _;
  }

  /**
   * Toggle on/off infinite approve.
   */
  function toggleInfiniteApprove() public returns (address) {
    address source = _msgSender();
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
    bool status = erc20.approve(address(this), amount);

    if (status) {
      return address(this);
    } else {
      revert("Approval failed.");
    }
  }

  // !SECTION

  // SECTION - Vector Component

  /**
   * Initiate a "space project" vector.
   * @param capacity The target amount of tokens "energy" necessary to activate the vector.
   * @param lifetime The window of time within which this vector should achieve its activation.
   * @param insight Description of the insight behind the vector.
   */
  function initiateVector(uint256 capacity, uint256 lifetime, string memory insight) public returns (bytes32) {
    address handler = _msgSender();
    bytes32 vectorId = keccak256(abi.encodePacked(block.timestamp, block.prevrandao));

    CSVectorsTable.set(
      vectorId,
      CSVectorsTableData({
        handler: handler,
        charge: 0,
        capacity: capacity,
        lifetime: lifetime,
        insight: insight,
        status: VectorStatus.CHANNELING
      })
    );

    return vectorId;
  }

  /**
   * Archive a vector.
   * @param vectorId Identifier of the vector.
   */
  function archiveVector(bytes32 vectorId) public onlyHandler(vectorId) {
    CSVectorsTable.setStatus(vectorId, VectorStatus.ARCHIVED);
  }

  /**
   * Transfer ownership of the vector.
   * @param vectorId Identifier of the vector
   * @param newHandler Address of the new owner
   */
  function transferVector(bytes32 vectorId, address newHandler) public onlyHandler(vectorId) {
    CSVectorsTable.setHandler(vectorId, newHandler);
  }

  // !SECTION

  // SECTION - Motion Component
  /**
   * Initiate a motion.
   * @param vectorId Identifier of the vector to which the motion belongs.
   * @param momentum Amount of tokens withdraw in order to execute the motion.
   * @param lifetime Timefram within which the motion should be executed.
   * @param target Address of the recipient of the withdrawn tokens.
   * @param insight Justification behind the motion
   */
  function initiateMotion(
    bytes32 vectorId,
    uint256 momentum,
    uint256 lifetime,
    address target,
    string memory insight
  ) public onlyHandler(vectorId) notArchived(vectorId) whenDischarging(vectorId) returns (bytes32) {
    bytes32 motionId = keccak256(abi.encodePacked(block.timestamp, block.prevrandao));

    CSMotionsTable.set(
      motionId,
      CSMotionsTableData({
        vectorId: vectorId,
        momentum: momentum,
        lifetime: lifetime,
        target: target,
        push: 0,
        pull: 0,
        status: MotionStatus.PENDING,
        insight: insight
      })
    );

    CSVectorMotionsLookupTable.pushMotionIds(vectorId, motionId);

    return motionId;
  }

  /**
   * Executes a motion. After it has been marked as proceeding.
   * @param motionId Identifier of the motion.
   */
  function executeMotion(bytes32 motionId) public payable onlyProceeding(motionId) {
    CSMotionsTableData memory motion = CSMotionsTable.get(motionId);
    CSVectorsTableData memory vector = CSVectorsTable.get(motion.vectorId);

    IERC20Mintable erc20 = BytesUtils.getToken(TOKEN_SYMBOL);
    erc20.transfer(motion.target, motion.momentum);

    CSVectorsTable.setCharge(motion.vectorId, vector.charge - motion.momentum);
  }

  /**
   * Cancel a motion.
   * @param motionId Identifier of the motion.
   *
   * @dev We need to cap the number of cancel per vector and let's say mark it as failing if it has 3 cancels.
   */
  function cancelMotion(bytes32 motionId) public {
    CSMotionsTable.setStatus(motionId, MotionStatus.CANCELLED);
  }

  // !SECTION

  // SECTION - Potential Component

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
  ) public notHandler(vectorId) withCapacityThreshold(vectorId, strength) whenChanneling(vectorId) returns (bytes32) {
    address source = _msgSender();

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
  function releaseEnergy(bytes32 vectorId) public onlyArchived(vectorId) onlyPotential(vectorId) {
    address source = _msgSender();

    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);

    bytes32 potentialId = AddressUtils.getPotentialId(source, vectorId);
    CSPotentialsTableData memory potential = CSPotentialsTable.get(potentialId);

    IERC20Mintable erc20 = BytesUtils.getToken(TOKEN_SYMBOL);
    erc20.transfer(source, potential.strength * 1 ether);

    // TODO - We need to remove the user from the list of potentials.
    CSVectorsTable.setCharge(vectorId, vector.charge - potential.strength);
  }

  // !SECTION

  // SECTION - Force Component
  /**
   * Apply force on an issued motion.
   * @param motionId Identifier of the motion.
   * @param direction Whether you support or oppose the motion.
   * @param insight A note to justify your action.
   */
  function applyForce(
    bytes32 motionId,
    ForceDirection direction,
    string memory insight
  ) public onlyPending(motionId) returns (bytes32) {
    address source = _msgSender();

    bytes32 forceId = keccak256(abi.encodePacked(block.timestamp, block.prevrandao));

    bytes32 vectorId = CSMotionsTable.getVectorId(motionId);

    bytes32 potentialId = source.getPotentialId(vectorId);
    CSPotentialsTableData memory potential = CSPotentialsTable.get(potentialId);
    CSVectorsTableData memory vector = CSVectorsTable.get(vectorId);
    CSMotionsTableData memory motion = CSMotionsTable.get(motionId);

    uint power = ((potential.strength * 100) / vector.capacity);

    if (direction == ForceDirection.ALONG) {
      CSMotionsTable.setPush(motionId, motion.push + power);
      if (motion.push > 50) {
        motion.status = MotionStatus.PROCEEDING;
      }
    } else {
      CSMotionsTable.setPull(motionId, motion.pull + power);
      if (motion.pull > 50) {
        motion.status = MotionStatus.HALTING;
      }
    }

    CSForcesTable.set(
      forceId,
      CSForcesTableData({
        power: power,
        direction: direction,
        insight: insight,
        motionId: motionId,
        potentialId: potentialId
      })
    );

    CSMotionForcesLookupTable.push(motionId, forceId);

    return forceId;
  }

  // !SECTION
}
