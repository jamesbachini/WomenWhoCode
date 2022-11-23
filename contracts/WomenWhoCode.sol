// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Token is ERC20 {
    constructor() ERC20("WomenWhoCode Token", "WWC") {
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }
}

contract WomenWhoCode is ERC721 {
    address public tokenAddress;
    uint public tokenId;
    mapping(uint => bool) public isAlien;

    constructor() ERC721("WomenWhoCode NFT", "WWC") {
        Token token = new Token();
        tokenAddress = address(token);
    }

    function earnTokens() public {
        IERC20(tokenAddress).transfer(msg.sender,100e18);
    }

    function mint() public {
        require(tokenId < 1000, "All 1000 tokens have been minted");
        _safeMint(msg.sender, tokenId);
        tokenId = tokenId + 1;
    }

    function makeAlien(uint _tokenId) public {
        uint balance = IERC20(tokenAddress).balanceOf(msg.sender);
        require(balance >= 100e18, "You don't have enough tokens");
        require(ownerOf(_tokenId) ==  msg.sender, "You do not own this NFT");
        isAlien[_tokenId] = true;
    }

    function tokenURI(uint256 _tokenId) override public view returns (string memory) {
        string memory json1 = '{"name": "WomenWhoCode", "description": "A dynamic NFT for WWC", "image": "https://cloudflare-ipfs.com/ipfs/';
        string memory json2;
        // Upload images to IPFS at https://nft.storage
        if (isAlien[_tokenId] == false) json2 = 'bafybeidrcvkt63y4ananxegwleuo43dddt5zhcvtuaiv2bfv2ge7o73ibi"}'; // avatar.png
        if (isAlien[_tokenId] == true) json2 = 'bafybeibyecyp6lxb3p4g27gwsijr5txx72bnfigetwoswhfnrbejla7gcm"}'; // alien.png
        string memory json = string.concat(json1, json2);
        string memory encoded = Base64.encode(bytes(json));
        return string(abi.encodePacked('data:application/json;base64,', encoded));
    }

}