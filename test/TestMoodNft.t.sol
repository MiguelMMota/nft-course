// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console2} from "forge-std/Test.sol";

import {DeployMoodNft} from "../script/DeployMoodNft.s.sol";
import {ServerConstants} from "../script/ServerConstants.s.sol";
import {MoodNft} from "../src/MoodNft.sol";

contract TestMoodNft is ServerConstants, Test {
    DeployMoodNft deployer;
    MoodNft public moodNft;

    string constant NFT_NAME = "Mood NFT";
    string constant NFT_SYMBOL = "MN";

    address public constant NFT_COLLECTOR = address(1);
    address public constant NFT_NOOB = address(2);

    modifier hasMintedNft() {
        vm.prank(NFT_COLLECTOR);
        moodNft.mintNft();
        console2.log(moodNft.tokenURI(0));
        _;
    }

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.createMoodNft();
    }

    function testInitialisedCorrectly() public {
        assertEq(moodNft.getTokenCounter(), 0);

        vm.expectRevert();
        assertEq(moodNft.tokenURI(0), "");

        console2.log(NFT_NAME, moodNft.name());
        console2.log(NFT_SYMBOL, moodNft.symbol());

        assertEq(keccak256(abi.encodePacked(moodNft.name())), keccak256(abi.encodePacked((NFT_NAME))));
        assertEq(keccak256(abi.encodePacked(moodNft.symbol())), keccak256(abi.encodePacked((NFT_SYMBOL))));
    }

    function testCanMintAndHaveBalance() public hasMintedNft {
        assert(moodNft.balanceOf(NFT_COLLECTOR) == 1);
    }

    function testTokenImageURIIsCorrect() public hasMintedNft {
        uint256 tokenId = moodNft.getTokenCounter() - 1;
        assertEq(keccak256(abi.encodePacked(moodNft.getImageUri(tokenId))), keccak256(abi.encodePacked(deployer.getImageUri(MoodNft.Mood.HAPPY))));
    }

    function testFlipTokenMood() public hasMintedNft {
        uint256 tokenId = 0;
        assertEq(uint256(moodNft.getTokenMood(tokenId)), uint256(MoodNft.Mood.HAPPY));

        // flips to sad
        vm.prank(NFT_COLLECTOR);
        moodNft.flipMood(tokenId);
        assertEq(uint256(moodNft.getTokenMood(tokenId)), uint256(MoodNft.Mood.SAD));

        // flips back to happy
        vm.prank(NFT_COLLECTOR);
        moodNft.flipMood(tokenId);
        assertEq(uint256(moodNft.getTokenMood(tokenId)), uint256(MoodNft.Mood.HAPPY));
    }

    function testNonOwnerCantFlipMood() public hasMintedNft {
        uint256 tokenId = 0;
        
        vm.expectRevert();
        vm.prank(NFT_NOOB);
        moodNft.flipMood(tokenId);
    }
}
