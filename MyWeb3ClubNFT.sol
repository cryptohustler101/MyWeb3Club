// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/Counters.sol";
import "./Base64.sol";

contract MyWeb3ClubNFT is ERC721Enumerable,ERC721URIStorage{
    address private owner;
    constructor()ERC721("MyWeb3Club","MWC"){
        owner=msg.sender;
    }
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    function mintNFT(address _creator,string memory _description,string memory _img)public returns(uint){


        uint tokenId=_tokenIds.current();


     
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "My Web3 Club #', toString(tokenId) ,'", "description":"',_description,'","image":"',_img,'","attributes":[{"display_type": "date", "trait_type": "timestamp", "value": ',toString(block.timestamp),'}]}'))));

       
        string memory tokenURL = string(abi.encodePacked('data:application/json;base64,', json));

   
        _mint(_creator,tokenId);
        _setTokenURI(tokenId,tokenURL);
        _tokenIds.increment();

        return tokenId;

        
    }




     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
        function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function toString(uint256 value) internal pure returns (string memory) {
  
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

}

