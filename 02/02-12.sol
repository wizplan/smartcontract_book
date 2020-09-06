// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

contract Enum {
    enum Colors {Red, Blue, Green}
    Colors color;

    function getColor() public view returns (Colors) {
        return color;
    }

    function setColor() public {
        color = Colors.Blue;
    }
}