// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;


import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error MoodNft__TokenUriNotFound();
    error MoodNft__TokenMoodNotFound();
    error MoodNft__CantFlipMoodIfNotOwner();

    enum Mood {
        HAPPY,
        SAD
    }

    string public s_sadSvgImageUri;
    string public s_happySvgImageUri;

    uint256 public s_tokenCounter;
    mapping(uint256 tokenId => Mood) private s_tokenIdToMood;

    constructor(string memory sadSvgImageUri, string memory happySvgImageUri) ERC721("Mood NFT", "MN") {
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;

        s_tokenCounter = 0;
    }

    function mintNft() public {
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function _isApprovedOrOwner(address sender, uint256 tokenId) private view returns (bool) {
        return getApproved(tokenId) == msg.sender || ownerOf(tokenId) == sender;
    }

    function flipMood(uint256 tokenId) public {
        if (!_isApprovedOrOwner(msg.sender, tokenId)) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }
    
    function getTokenMood(uint256 tokenId) public view returns (Mood) {
        if (ownerOf(tokenId) == address(0)) {
            revert MoodNft__TokenMoodNotFound();
        }

        return s_tokenIdToMood[tokenId];
    }

    function _baseURI() internal pure override returns(string memory) {
        return "data:application/json;base64,";
    }

    function getImageUri(uint256 tokenId) public view returns(string memory) {
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            return s_happySvgImageUri;
        } else {
            return s_sadSvgImageUri;
        }
    }

    function tokenURI(uint256 tokenId) public view override returns(string memory) {
        if (ownerOf(tokenId) == address(0)) {
            revert MoodNft__TokenUriNotFound();
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "An NFT that reflects the owner\'s mood",', 
                            '"image":"',
                            getImageUri(tokenId),
                            '", "attributes": [{"trait_type": "moodiness","value": 100}]}'
                        )
                    )
                )
            )
        );
    }

    function getHappySVG() public view returns (string memory) {
        return s_happySvgImageUri;
    }

    function getSadSVG() public view returns (string memory) {
        return s_sadSvgImageUri;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}