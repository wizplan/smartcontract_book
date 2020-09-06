// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "../@openzeppelin/contracts/access/Ownable.sol";
import "../@openzeppelin/contracts/utils/Pausable.sol";
import "./Activatable.sol"; // ①

// ②
contract Room is Ownable, Pausable, Activatable {
    address _owner = owner();

    mapping (uint256 => bool) public rewardSent;

    event Deposited(address indexed _depositor, uint256 _depositedValue);
    event RewardSent(address indexed _dest, uint256 _reward, uint256 _id);
    event RefundedToOwner(address indexed _dest, uint256 _refundedBalance);

    constructor(address _creator) payable {
        _owner = _creator;
    }

    function deposit() external payable whenNotPaused {
        require(msg.value > 0, "");
        emit Deposited(msg.sender, msg.value);
    }

    function sendReward(uint256 _reward, address _dest, uint256 _id) external onlyOwner {
        require(!rewardSent[_id], "");
        require(_reward > 0, "");
        require(address(this).balance >= _reward, "");
        require(_dest != _owner, "");

        rewardSent[_id] = true;
        address(uint160(_dest)).transfer(_reward);
        emit RewardSent(_dest, _reward, _id);
    }

    // ③
    function refundToOwner() external whenNotActive onlyOwner {
        require(address(this).balance > 0, "");
        uint256 refundedBalance = address(this).balance;
        address(uint160(_owner)).transfer(refundedBalance);
        emit RefundedToOwner(msg.sender, refundedBalance);
    }
}