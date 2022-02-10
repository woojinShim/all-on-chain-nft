// give the contract some SVG code
// output an NFT URI with this SVG code
// Storing all the NFT metadata on-chain

// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract SVGNFT is ERC721URIStorage {
    constructor() ERC721 ("SVG NFT", "svgNFT") {

    }

    function create(string memory svg) public {
        _safeMint(msg.sender, ???);
    }
}