// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IMangrovePoints} from "./IMangrovePoints.sol";

/**
 * @title MangrovePoints
 * @notice A contract for managing operators for accounts
 * @dev Inherits from OpenZeppelin's Ownable contract
 */
contract MangrovePoints is Ownable(msg.sender), IMangrovePoints {
  /**
   * @inheritdoc IMangrovePoints
   */
  mapping(address => address) public operators;

  /**
   * @notice Checks if the caller is allowed to change the operator for an account
   * @param account The account for which the operator change is being checked
   * @return canSet True if the caller is allowed to change the operator, false otherwise
   * @dev The caller is allowed if they are the account itself (when no operator is set) or the current operator
   */
  function _isAllowedToChangeOperatorFor(address account) internal view returns (bool canSet) {
    address currentOperator = operators[account];
    canSet = currentOperator == address(0) ? msg.sender == account : msg.sender == currentOperator;
  }

  /**
   * @inheritdoc IMangrovePoints
   * @dev If the caller is not allowed to change the operator, it falls back to checking if the caller is the owner
   */
  function setOperator(address account, address operator) public {
    if (!_isAllowedToChangeOperatorFor(account)) {
      _checkOwner();
    }
    operators[account] = operator;
    emit OperatorSet(account, operator);
  }
}
