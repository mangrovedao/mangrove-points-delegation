// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IMangrovePoints
 * @notice Interface for the MangrovePoints contract
 */
interface IMangrovePoints {
  /**
   * @notice Emitted when an operator is set for an account
   * @param account The account for which the operator is set
   * @param operator The address of the operator
   */
  event OperatorSet(address indexed account, address indexed operator);

  /**
   * @notice Sets the operator for an account
   * @param account The account for which to set the operator
   * @param operator The address to set as the operator
   */
  function setOperator(address account, address operator) external;

  /**
   * @notice Returns the operator for a given account
   * @param account The account to check
   * @return The address of the operator for the given account
   */
  function operators(address account) external view returns (address);
}
