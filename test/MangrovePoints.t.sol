// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MangrovePoints} from "../src/MangrovePoints.sol";

contract MangrovePointsTest is Test {
  MangrovePoints public mangrovePoints;

  function setUp() public {
    mangrovePoints = new MangrovePoints();
  }

  function test_Increment() public {
    mangrovePoints.increment();
    assertEq(mangrovePoints.number(), 1);
  }

  function testFuzz_SetNumber(uint256 x) public {
    mangrovePoints.setNumber(x);
    assertEq(mangrovePoints.number(), x);
  }
}
