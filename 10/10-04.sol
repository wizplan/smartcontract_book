// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "./@openzeppelin/contracts/math/SafeMath.sol";

contract WithdrawalContract {
    using SafeMath for uint256;
    mapping(address => uint256) private _deposits;

    function deposit() public payable {
        uint256 amount = msg.value;
        _deposits[msg.sender] = _deposits[msg.sender].add(amount);
    }

    function withdraw() public {
        uint256 amount = _deposits[msg.sender];
        require(amount > 0, "");
        _deposits[msg.sender] = 0;
        msg.sender.transfer(amount);
    }
}