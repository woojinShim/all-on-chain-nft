// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "./SVGNFT.sol";

contract Random is ERC721URIStorage, VRFConsumerBase {
    bytes32 public keyHash;
    uint256 public fee;
    uint256 public tokenCounter;

    // SVG parameters
    uint256 public maxNumberOfPaths;
    uint256 public maxNumberOfPathCommands;
    uint256 public size;
    string[] public pathCommands;
    string[] public colors;

    mapping(bytes32 => address) public requestIdToSender;
    mapping(bytes32 => uint256) public requestIdToTokenId;
    mapping(uint256 => uint256) public tokenIdToRandomNumber;

    event requestedRandom(bytes32 indexed requestId, uint256 indexed tokenId);
    event CreatedUnfinishedRandomNFT(
        uint256 indexed tokenId,
        uint256 randomNumber
    );
    event CreatedRandomNFT(
        uint256 indexed tokenId,
        string tokenURI
    );

    constructor(
        address _VRFCoordinator,
        address _LinkToken,
        bytes32 _keyHash,
        uint256 _fee
    ) VRFConsumerBase(_VRFCoordinator, _LinkToken) ERC721("RandomNFT", "rNFT") {
        fee = _fee;
        keyHash = _keyHash;
        tokenCounter = 0;

        maxNumberOfPaths = 10;
        maxNumberOfPathCommands = 5;
        size = 500;
        pathCommands = ["M", "L"];
        colors = ["red", "blue", "green", "yellow", "black", "white"];
    }

    function create() public returns (bytes32 requestId) {
        requestId = requestRandomness(keyHash, fee);
        requestIdToSender[requestId] = msg.sender;
        uint256 tokenId = tokenCounter;
        requestIdToTokenId[requestId] = tokenId;
        tokenCounter = tokenCounter + 1;
        emit requestedRandom(requestId, tokenId);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber)
        internal
        override
    {
        address nftOwner = requestIdToSender[requestId];
        uint256 tokenId = requestIdToTokenId[requestId];
        _safeMint(nftOwner, tokenId);

        tokenIdToRandomNumber[tokenId] = randomNumber;
        emit CreatedUnfinishedRandomNFT(tokenId, randomNumber);
    }

    function finishMint(uint256 _tokenId) public {
        // [x] check to see if it's been minted and a random number is returned
        // [] generate some random SVG code
        // [] turn that into an image URI
        // [] use that imageURI to format into a tokenURI
        require(bytes(tokenURI(_tokenId)).length <= 0, "tokenURI is already all set!");
        require(tokenCounter > _tokenId, "TokenId has not been minted yet!");
        require(tokenIdToRandomNumber[_tokenId] > 0, "Need to wait for Chainlink VRF");
        uint256 randomNumber tokenIdToRandomNumber[_tokenId];
        string memory svg = generateSVG(randomNumber);
        string memory imageURI = svgToImageURI(svg);
        string memory tokenURI = formatTokenURI(imageURI);
        _setTokenURI(_tokenId, tokenURI);
        emit CreatedRandomNFT(_tokenId, svg);
    }

    function generateSVG(uint256 _randomNumber) public view returns (string memory finalSvg) {

    }
}
