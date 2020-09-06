pragma solidity >=0.5.0 <0.6.0;

// 0.7.x 대응
// SPDX-License-Identifier: MIT
// pragma solidity >=0.5.0 <0.8.0;

import "./zombieattack.sol";
import "./erc721.sol";
import "./safemath.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {
// 0.7.x 대응
// abstract contract ZombieOwnership is ZombieAttack, ERC721 {
    using SafeMath for uint256;

    mapping (uint => address) zombieApprovals;

    function balanceOf(address _owner) external view returns (uint256) {
    // 0.7.x 대응
    // function balanceOf(address _owner) external view override returns (uint256) {
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
    // 0.7.x 대응
    // function ownerOf(uint256 _tokenId) external view override returns (address) {
        return zombieToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        zombieToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external {
    // 0.7.x 대응
    // function transferFrom(address _from, address _to, uint256 _tokenId) external override {
        require(zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender, "");
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external onlyOwnerOf(_tokenId) {
    // 0.7.x 대응
    // function approve(address _approved, uint256 _tokenId) external override onlyOwnerOf(_tokenId) {
        zombieApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
}