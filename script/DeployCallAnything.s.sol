// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

import {CallAnything} from "../src/CallAnything.sol";

contract DeployCallAnything is Script {
    function createCallAnything() public returns (CallAnything) {
        vm.startBroadcast();
        CallAnything callAnything = new CallAnything();
        vm.stopBroadcast();

        return callAnything;
    }

    function run() external returns (CallAnything) {
        return createCallAnything();
    }
}
