// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

contract MappingExample {
    mapping(address => uint) public balances;

    function update(uint newBalance) public {
        balances[msg.sender] = newBalance;
    }
}