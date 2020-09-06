// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

contract DataStore {
    uint public storedData;

    constructor() {
        storedData = 100;
    }
}