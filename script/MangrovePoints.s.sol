// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MangrovePoints} from "../src/MangrovePoints.sol";

contract MangrovePointsScript is Script {
  MangrovePoints public mangrovePoints;

  function setUp() public {}

  function run() public {
    vm.startBroadcast();

    mangrovePoints = new MangrovePoints();

    vm.stopBroadcast();
  }
}
