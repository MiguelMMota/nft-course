// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console2} from "forge-std/Script.sol";

import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

import {ServerConstants} from "../script/ServerConstants.s.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {MoodNft} from "../src/MoodNft.sol";

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

contract MintMoodNft is Script {

    function mintNftOnContract(address moodNftAddress) public {
        MoodNft moodNft = MoodNft(moodNftAddress);

        vm.startBroadcast();
        moodNft.mintNft();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployedBasicNft = DevOpsTools
            .get_most_recent_deployment("MoodNft", block.chainid);
        mintNftOnContract(mostRecentlyDeployedBasicNft);
    }
}

contract FlipMoodNft is Script {

    uint256 tokenId = vm.envOr("TOKEN_ID", uint256(0));

    function flipNftOnContract(address moodNftAddress) public {
        MoodNft moodNft = MoodNft(moodNftAddress);

        vm.startBroadcast();
        moodNft.flipMood(tokenId);
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployedBasicNft = DevOpsTools
            .get_most_recent_deployment("MoodNft", block.chainid);
        flipNftOnContract(mostRecentlyDeployedBasicNft);
    }
}
