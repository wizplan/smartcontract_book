// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

contract ReturnStruct {
    struct Author {
        address addr;
        string name;
    }

    Author[] public authors;

    constructor() { }

    function getAuthor() public returns (Author memory) {
        address authorAddr = 0x0cE446255506E92DF41614C46F1d6df9Cc969183;
        authors.push(Author(authorAddr, 'blockchain_lab'));
        return authors[0];
    }
}