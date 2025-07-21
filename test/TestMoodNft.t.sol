// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";

import {DeployMoodNft} from "../script/DeployMoodNft.s.sol";
import {ServerConstants} from "../script/ServerConstants.s.sol";
import {MoodNft} from "../src/MoodNft.sol";

contract TestMoodNft is ServerConstants, Test {
    DeployMoodNft deployer;
    MoodNft public moodNft;

    string private constant NFT_NAME = "Mood NFT";
    string private constant NFT_SYMBOL = "MN";

    string private constant HAPPY_TOKEN_URI = 
        "data:application/json;base64,eyJuYW1lIjogIk1vb2QgTkZUIiwgImRlc2NyaXB0aW9uIjogIkFuIE5GVCB0aGF0IHJlZmxlY3RzIHRoZSBvd25lcidzIG1vb2QiLCJpbWFnZSI6ImRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5QjJhV1YzUW05NFBTSXdJREFnTWpBd0lESXdNQ0lnZDJsa2RHZzlJalF3TUNJZ0lHaGxhV2RvZEQwaU5EQXdJaUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lQZ29nSUR4amFYSmpiR1VnWTNnOUlqRXdNQ0lnWTNrOUlqRXdNQ0lnWm1sc2JEMGllV1ZzYkc5M0lpQnlQU0kzT0NJZ2MzUnliMnRsUFNKaWJHRmpheUlnYzNSeWIydGxMWGRwWkhSb1BTSXpJaTgrQ2lBZ1BHY2dZMnhoYzNNOUltVjVaWE1pUGdvZ0lDQWdQR05wY21Oc1pTQmplRDBpTnpBaUlHTjVQU0k0TWlJZ2NqMGlNVElpTHo0S0lDQWdJRHhqYVhKamJHVWdZM2c5SWpFeU55SWdZM2s5SWpneUlpQnlQU0l4TWlJdlBnb2dJRHd2Wno0S0lDQThjR0YwYUNCa1BTSnRNVE0yTGpneElERXhOaTQxTTJNdU5qa2dNall1TVRjdE5qUXVNVEVnTkRJdE9ERXVOVEl0TGpjeklpQnpkSGxzWlQwaVptbHNiRHB1YjI1bE95QnpkSEp2YTJVNklHSnNZV05yT3lCemRISnZhMlV0ZDJsa2RHZzZJRE03SWk4K0Nqd3ZjM1puUGdvPSIsICJhdHRyaWJ1dGVzIjogW3sidHJhaXRfdHlwZSI6ICJtb29kaW5lc3MiLCJ2YWx1ZSI6IDEwMH1dfQ==";

    address public constant NFT_COLLECTOR = address(1);
    address public constant NFT_NOOB = address(2);

    modifier hasMintedNft() {
        vm.prank(NFT_COLLECTOR);
        moodNft.mintNft();
        _;
    }

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.createMoodNft();
    }

    function testInitialisedCorrectly() public {
        assertEq(moodNft.getTokenCounter(), 0);

        vm.expectRevert();
        moodNft.tokenURI(0);

        assertEq(keccak256(abi.encodePacked(moodNft.name())), keccak256(abi.encodePacked((NFT_NAME))));
        assertEq(keccak256(abi.encodePacked(moodNft.symbol())), keccak256(abi.encodePacked((NFT_SYMBOL))));
    }

    function testCanMintAndHaveBalance() public hasMintedNft {
        assert(moodNft.balanceOf(NFT_COLLECTOR) == 1);
    }

    function testTokenImageURIIsCorrect() public hasMintedNft {
        uint256 tokenId = moodNft.getTokenCounter() - 1;
        assertEq(keccak256(abi.encodePacked(moodNft.getImageUri(tokenId))), keccak256(abi.encodePacked(deployer.getImageUri(MoodNft.Mood.HAPPY))));
        assertEq(keccak256(abi.encodePacked(moodNft.tokenURI(tokenId))), keccak256(abi.encodePacked(HAPPY_TOKEN_URI)));
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
