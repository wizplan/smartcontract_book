// SPDX-License-Identifier: MIT
// solium-disable linebreak-style
pragma solidity >=0.4.22 <0.8.0;

contract Factory {
    Child[] childList;

    function createChildContract() public payable {
        Child child = new Child(msg.sender);
        childList.push(child);
    }

    function getDeployedChildContracts() public view returns (Child[] memory) {
        return childList;
    }
}

contract Child {
    address owner;

    constructor(address _owner) {
        owner = _owner;
    }
}