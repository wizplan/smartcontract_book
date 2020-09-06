// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

contract Purchase {
    address public seller;
    modifier onlySeller() { // 함수 제한자
        require (
            msg.sender == seller,
            "Only seller can call this."
        );
        _;
    }
    function abort() public view onlySeller { // 함수 제한자 사용
        // ...
    }
}