// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "MintSoundToken.sol";

contract SaleSoundToken {
    MintSoundToken public mintSoundTokenAddress;

    constructor(address _mintSoundTokenAddress) {
        mintSoundTokenAddress = MintSoundToken(_mintSoundTokenAddress);
    }

    mapping(uint256 => uint256) public soundTokenPrices;

    uint256[] public onSaleSoundTokenArray;

    //팔 대상과 가격
    function setForSaleSoundToken(uint256 _soundTokenId, uint256 _price)
        public
    {
        address soundTokenOwner = mintSoundTokenAddress.ownerOf(_soundTokenId);

        require(soundTokenOwner == msg.sender, "Caller is not sound owner");
        require(_price > 0, "price is zero or lower");
        require(
            soundTokenPrices[_soundTokenId] == 0,
            "This sound token is already on sale"
        );
        require(
            mintSoundTokenAddress.isApprovedForAll(
                soundTokenOwner,
                address(this)
            ),
            "sound token owner did not approve token"
        );

        soundTokenPrices[_soundTokenId] = _price;

        onSaleSoundTokenArray.push(_soundTokenId);
    }

    function purchaseAnimalToken(uint256 _soundTokenId) public payable {
        uint256 price = soundTokenPrices[_soundTokenId];
        address soundTokenOwner = mintSoundTokenAddress.ownerOf(_soundTokenId);

        require(price > 0, "Sound token not sale");
        require(price <= msg.value, "Caller sent lower than price");
        require(soundTokenOwner != msg.sender, "Caller is sound token owner");

        //돈을 보내고 nft를 받아오는 내장함수
        payable(soundTokenOwner).transfer(msg.value);
        //인자는 순서대로 보내는 사람 받는 사람 보내는 것
        mintSoundTokenAddress.safeTransferFrom(
            soundTokenOwner,
            msg.sender,
            _soundTokenId
        );

        soundTokenPrices[_soundTokenId] = 0;

        for (uint256 i = 0; i < onSaleSoundTokenArray.length; i++) {
            if (soundTokenPrices[onSaleSoundTokenArray[i]] == 0) {
                onSaleSoundTokenArray[i] = onSaleSoundTokenArray[
                    onSaleSoundTokenArray.length - 1
                ];
                onSaleSoundTokenArray.pop();
            }
        }
    }

    function getOnSaleSoundTokenArrayLength() public view returns (uint256) {
        return onSaleSoundTokenArray.length;
    }
}
