// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

import {ServerConstants} from "../script/ServerConstants.s.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract MintBasicNft is ServerConstants, Script {

    function mintNftOnContract(address basicNftAddress) public {
        BasicNft basicNft = BasicNft(basicNftAddress);

        vm.startBroadcast();
        basicNft.mintNft(PUG_URI);
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployedBasicNft = DevOpsTools
            .get_most_recent_deployment("BasicNft", block.chainid);
        mintNftOnContract(mostRecentlyDeployedBasicNft);
    }
}
