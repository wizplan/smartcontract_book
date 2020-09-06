// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "./@openzeppelin/contracts/utils/Pausable.sol";

contract PausableSample is Pausable {
    constructor() payable { }

    function normalFunction() public whenNotPaused {
        // one can do only when not paused
    }
}