// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MintSoundToken is ERC721Enumerable {
  constructor() ERC721("morakSound", "HAS"){}

  mapping(uint256 => uint256) public soundTypes;

  function mintSoundToken() public {
    uint256 soundTokenId = totalSupply() + 1;
    //1번부터 5번까지 랜덤으로 들어온다.
    uint256 soundType = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, soundTokenId))) % 5 + 1 ;

    soundTypes[soundTokenId] = soundType; 

    _mint(msg.sender, soundTokenId);
  }
}