// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

import {ServerConstants} from "./ServerConstants.s.sol";
import {MoodNft} from "../src/MoodNft.sol";

contract DeployMoodNft is ServerConstants, Script {
    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory) {
        // example input:
        // '<svg width="500" height="500" viewBox="0 0 285 350" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill="black" d="M150,0,L75,200,L225,200,Z"></path></svg>'
        return
            string.concat(
                "data:image/svg+xml;base64,",
                Base64.encode(abi.encodePacked(svg))
            );
    }

    function getImageUri(
        MoodNft.Mood mood
    ) public view returns (string memory) {
        string memory filename = "happy";
        if (mood == MoodNft.Mood.SAD) {
            filename = "sad";
        }

        string memory svg = vm.readFile(
            string.concat("./images/dynamicNft/", filename, ".svg")
        );
        return svgToImageURI(svg);
    }

    function createMoodNft() public returns (MoodNft) {
        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(
            getImageUri(MoodNft.Mood.SAD),
            getImageUri(MoodNft.Mood.HAPPY)
        );
        vm.stopBroadcast();

        return moodNft;
    }

    function run() external returns (MoodNft) {
        return createMoodNft();
    }
}
