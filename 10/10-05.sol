// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "./@openzeppelin/contracts/access/Ownable.sol";

contract SelfDestructive is Ownable {
    constructor() payable { }

    function destroy(address payable _recipient) public onlyOwner {
        selfdestruct(_recipient);
    }
}