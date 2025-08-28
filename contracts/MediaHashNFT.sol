// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MediaHashNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    using ECDSA for bytes32;

    Counters.Counter private _tokenIdCounter;
    address public trustedSigner;

    mapping(uint256 => bytes32) public contentHashOf;

    event Minted(address indexed to, uint256 indexed tokenId, bytes32 contentHash);

    constructor(address signer_) ERC721("MediaHashNFT", "MHNFT") {
        trustedSigner = signer_;
    }

    function setTrustedSigner(address signer_) external onlyOwner {
        trustedSigner = signer_;
    }

    function mint(bytes32 contentHash, bytes calldata sig) external {
        bytes32 message = keccak256(abi.encodePacked(contentHash, msg.sender));
        bytes32 ethSignedMessage = message.toEthSignedMessageHash();

        address signer = ethSignedMessage.recover(sig);
        require(signer == trustedSigner, "invalid signature");

        _tokenIdCounter.increment();
        uint256 newId = _tokenIdCounter.current();

        contentHashOf[newId] = contentHash;
        _safeMint(msg.sender, newId);

        emit Minted(msg.sender, newId, contentHash);
    }
}