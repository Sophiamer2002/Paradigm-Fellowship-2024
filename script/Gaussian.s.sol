// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Gaussian} from "../src/Gaussian.sol";

contract GaussianScript is Script {
    Gaussian public gaussian;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        gaussian = new Gaussian();

        vm.stopBroadcast();
    }
}
