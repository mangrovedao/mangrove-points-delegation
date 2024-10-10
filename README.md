# MangrovePoints

MangrovePoints is a smart contract designed to keep track of the custom maker contract links with their owners. This contract allows for the management of operators for accounts, providing a flexible and secure way to handle permissions.

## How to Use

To use the MangrovePoints contract in your custom maker contract, follow these steps:

1. Include the IMangrovePoints interface in your contract:

```solidity
import {IMangrovePoints} from "./IMangrovePoints.sol";
```

2. Call the `setOperator` method directly from your contract:

```solidity
IMangrovePoints mangrovePoints = IMangrovePoints(MANGROVE_POINTS_ADDRESS);
mangrovePoints.setOperator(address(this), OPERATOR_ADDRESS);
```

Replace `MANGROVE_POINTS_ADDRESS` with the deployed address of the MangrovePoints contract, and `OPERATOR_ADDRESS` with the address you want to set as the operator for your contract.

## Mangrove's Role

While the primary method for setting operators is through the custom maker contracts themselves, Mangrove also has the ability to add operators in cases where the contract may have missed calling this function. However, this is subject to certain conditions:

- There must be a proof linking the custom maker contract to the admin, deployer, or other authorized entity.
- It will be at Mangrove's discretion to accept or refuse any requests for operator assignment.

This feature ensures that legitimate contracts are not left without operators due to oversight or technical issues, while maintaining the integrity of the system.

## How MangrovePoints Works

The MangrovePoints contract is built on OpenZeppelin's Ownable contract and implements the IMangrovePoints interface. Here's an overview of its functionality:

```solidity
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
```

1. The contract maintains a mapping of accounts to their operators.
2. The `setOperator` function allows for setting or changing the operator for an account.
3. There are checks in place to ensure that only authorized entities can change operators:
   - The account itself can set its operator if no operator is currently set.
   - The current operator can change the operator.
   - The owner of the MangrovePoints contract can set operators as a fallback.
4. When an operator is set or changed, an `OperatorSet` event is emitted.

The contract uses an internal function `_isAllowedToChangeOperatorFor` to determine if the caller is allowed to change the operator for a given account.