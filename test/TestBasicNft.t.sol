// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";

import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {ServerConstants} from "../script/ServerConstants.s.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract TestBasicNft is ServerConstants, Test {
    DeployBasicNft deployer;
    BasicNft public basicNft;

    string constant NFT_NAME = "Dogie";
    string constant NFT_SYMBOL = "DOG";

    address public constant NFT_COLLECTOR = address(1);

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.createBasicNft();
    }

    function testInitialisedCorrectly() public {
        assertEq(basicNft.getTokenCounter(), 0);

        vm.expectRevert();
        assertEq(basicNft.tokenURI(0), "");

        assertEq(keccak256(abi.encodePacked(basicNft.name())), keccak256(abi.encodePacked((NFT_NAME))));
        assertEq(keccak256(abi.encodePacked(basicNft.symbol())), keccak256(abi.encodePacked((NFT_SYMBOL))));
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(NFT_COLLECTOR);
        basicNft.mintNft(PUG_URI);

        assert(basicNft.balanceOf(NFT_COLLECTOR) == 1);
    }

    function testTokenURIIsCorrect() public {
        vm.prank(NFT_COLLECTOR);
        basicNft.mintNft(PUG_URI);

        uint256 tokenId = basicNft.getTokenCounter() - 1;
        assertEq(keccak256(abi.encodePacked(basicNft.tokenURI(tokenId))), keccak256(abi.encodePacked(PUG_URI)));
    }
}
