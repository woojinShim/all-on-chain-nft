// give the contract some SVG code
// output an NFT URI with this SVG code
// Storing all the NFT metadata on-chain

// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "base64-sol/base64.sol";

contract SVGNFT is ERC721URIStorage {
    uint256 public tokenCounter;

    constructor() ERC721("SVG NFT", "svgNFT") {
        tokenCounter = 0;
    }

    function create(string memory _svg) public {
        _safeMint(msg.sender, tokenCounter);
        // imageURI
        string memory imageURI = svgToImageURI(svg);
        // tokenURI
        string memory tokenURI = formateTokenURI(imageURI);
        // NFT 번호 부여
        _setTokenURI(tokenCounter, tokenURI);
        tokenCounter = tokenCounter + 1;
    }
    // base64-sol으로 이미지 인코딩
    function setToImageURI(string memory _svg) public pure returns (string memory) {
        // <svg xmlns="http://www.w3.org/2000/svg" width="100" height="100"><circle cx="50" cy="50" r="40" stroke="green" stroke-width="4" fill="yellow" /></svg> 
        // data:image/svg+xml;base64,<Base65-encoding>
        string memory baseURL = "data:image/svg+xml;base64,"; 
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(_svg))));
        string memory imageURI = string(abi.encodePacked(baseURL, svgBase64Encoded));
        return imageURI;
    }
    // tokenURI를 json
    function formateTokenURI(string memory _imageURI) public pure returns (string memory) {
        string memory baseURL = "data:application/json;base64";
        return string(abi.encondePacked(
            baseURL,
        Base64.enconde(
            bytes(abi.edcodePacked(
                '{"name": "SVG NFT", 
                '"description": "An NFT based on SVG!"', 
                '"attributes": ""',
                '"image": "', _imageURI, '"}'
            )
            )));
    }
}
