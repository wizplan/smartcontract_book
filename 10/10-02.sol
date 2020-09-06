// SPDX-License-Identifier: MIT
// solium-disable linebreak-style
pragma solidity >=0.4.22 <0.8.0;

contract NameRegistry {
    mapping(string => address) registry;

    function registerName(string memory name, address addr) public returns (bool) {
        registry[name] = addr;
        return true;
    }

    function getContractAddress(string memory name) public view returns(address) {
        return registry[name];
    }
}