// SPDX-License-Identifier: MIT
/* 코드 6-7
pragma solidity >=0.4.22 <0.8.0;

// ①
import "./Room.sol";

contract RoomFactory {
    // ②
    function createRoom() external payable {
        Room room = new Room{value: msg.value}(msg.sender);
    }
} */

/* 코드 6-11 */
pragma solidity >=0.4.22 <0.8.0;

// ①
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "./Room.sol";

// import "../06/openzeppelin/access/Ownable.sol";
// import "../06/openzeppelin/utils/Pausable.sol";
// import "./Room.sol";

// ②
contract RoomFactory is Ownable, Pausable {
    // ③
    event RoomCreated(address indexed _creator, address _room, uint256 _depositedValue);

    // ④
    function createRoom() external payable whenNotPaused {
        Room room = new Room{value: msg.value}(msg.sender);
        emit RoomCreated(msg.sender, address(room), msg.value);
    }
}