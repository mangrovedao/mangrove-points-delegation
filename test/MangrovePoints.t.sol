// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {IMangrovePoints, MangrovePoints, Ownable} from "../src/MangrovePoints.sol";

contract MangrovePointsTest is Test {
  MangrovePoints public mangrovePoints;
  address public owner;
  address public user1;
  address public user2;

  function setUp() public {
    owner = address(this);
    user1 = address(0x1);
    user2 = address(0x2);
    mangrovePoints = new MangrovePoints();
  }

  function test_InitialOwnership() public view {
    assertEq(mangrovePoints.owner(), owner);
  }

  function test_SetOperatorByOwner() public {
    mangrovePoints.setOperator(user1, user2);
    assertEq(mangrovePoints.operators(user1), user2);
  }

  function test_SetOperatorByAccount() public {
    vm.prank(user1);
    mangrovePoints.setOperator(user1, user2);
    assertEq(mangrovePoints.operators(user1), user2);
  }

  function test_SetOperatorByCurrentOperator() public {
    mangrovePoints.setOperator(user1, user2);
    vm.prank(user2);
    mangrovePoints.setOperator(user1, address(0x3));
    assertEq(mangrovePoints.operators(user1), address(0x3));
  }

  function test_FailSetOperatorByUnauthorized() public {
    vm.prank(user2);
    vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, user2));
    mangrovePoints.setOperator(user1, user2);
  }

  function test_EmitOperatorSetEvent() public {
    vm.expectEmit(true, true, false, true);
    emit IMangrovePoints.OperatorSet(user1, user2);
    mangrovePoints.setOperator(user1, user2);
  }
}
