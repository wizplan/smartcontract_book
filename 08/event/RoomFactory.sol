// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

// ①
import "../@openzeppelin/contracts/access/Ownable.sol";
import "../@openzeppelin/contracts/utils/Pausable.sol";
import "./Room.sol";

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