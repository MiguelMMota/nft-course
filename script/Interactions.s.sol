// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console2} from "forge-std/Script.sol";

import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

import {ServerConstants} from "../script/ServerConstants.s.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {CallAnything} from "../src/CallAnything.sol";
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
        address mostRecentlyDeployedMoodNft = DevOpsTools
            .get_most_recent_deployment("MoodNft", block.chainid);
        mintNftOnContract(mostRecentlyDeployedMoodNft);
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
        address mostRecentlyDeployedMoodNft = DevOpsTools
            .get_most_recent_deployment("MoodNft", block.chainid);
        flipNftOnContract(mostRecentlyDeployedMoodNft);
    }
}

contract CallTransferFunctionWithSelector is Script {

    uint256 transferAmount = vm.envOr("TRANSFER_AMOUNT", uint256(0));

    function callTransferWithSelector(address callAnythingAddress) public {
        CallAnything callAnything = CallAnything(callAnythingAddress);

        address someAddress = address(1);
        uint256 someAmount = 3 ether;        

        vm.startBroadcast();
        callAnything.callFunctionWithSelector(someAddress, someAmount);
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployedCallAnything = DevOpsTools
            .get_most_recent_deployment("CallAnything", block.chainid);
        callTransferWithSelector(mostRecentlyDeployedCallAnything);
    }
}
