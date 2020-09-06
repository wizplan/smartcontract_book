// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

contract Deposit {
    uint depositThreshold;
    event LogDeposit(uint _time);

    constructor() {
        depositThreshold = 1 ether;
    }

    function deposit() public payable {
        require(msg.value >= depositThreshold, "");
        emit LogDeposit(block.timestamp);
    }

    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }
}