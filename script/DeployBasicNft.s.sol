// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

import {BasicNft} from "../src/BasicNft.sol";

contract DeployBasicNft is Script {
    function createBasicNft() public returns (BasicNft) {
        vm.startBroadcast();
        BasicNft basicNft = new BasicNft();
        vm.stopBroadcast();

        return basicNft;
    }

    function run() external returns (BasicNft) {
        return createBasicNft();
    }
}
