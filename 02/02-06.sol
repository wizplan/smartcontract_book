// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

contract SimpleAuction {
    event HighestBidIncreased(address bidder, uint amount); // 이벤트 정의
    function bid() public payable {
        // ...
        emit HighestBidIncreased(msg.sender, msg.value); // 이벤트 실행
    }
}