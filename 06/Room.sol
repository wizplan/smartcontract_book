// SPDX-License-Identifier: MIT
/* 코드 6-6
pragma solidity >=0.4.22 <0.8.0;

// ①
import "@openzeppelin/contracts/access/Ownable.sol";

// ②
contract Room is Ownable {
    address _owner = owner();

    // ③
    constructor(address _creator) payable {
        _owner = _creator;
    }

    // ④
    function deposit() external payable { }

    // ⑤
    function sendReward(uint256 _reward, address _dest) external onlyOwner {
        address(uint160(_dest)).transfer(_reward);
    }

    // ⑥
    function refundToOwner() external onlyOwner {
        address(uint160(_owner)).transfer(address(this).balance);
    }
} */

/* 코드 6-8
pragma solidity >=0.4.22 <0.8.0;

// ①
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

// import "../06/openzeppelin/access/Ownable.sol";
// import "../06/openzeppelin/utils/Pausable.sol";

contract Room is Ownable, Pausable {
    address _owner = owner();

    // ②
    mapping (uint256 => bool) public rewardSent;

    // ③
    event Deposited(address indexed _depositor, uint256 _depositedValue);

    // ④
    event RewardSent(address indexed _dest, uint256 _reward, uint256 _id);

    // ⑤
    event RefundedToOwner(address indexed _dest, uint256 _refundedBalance);

    constructor(address _creator) payable {
        _owner = _creator;
    }

    // ⑥
    function deposit() external payable whenNotPaused {
        require(msg.value > 0, ""); // ⑦
        emit Deposited(msg.sender, msg.value);
    }

    // ⑧
    function sendReward(uint256 _reward, address _dest, uint256 _id) external onlyOwner {
        require(!rewardSent[_id], ""); // ⑨
        require(_reward > 0, ""); // ⑩
        require(address(this).balance >= _reward, ""); // ⑪
        require(_dest != address(0), ""); // ⑫
        require(_dest != _owner, ""); // ⑬

        rewardSent[_id] = true; // ⑨
        address(uint160(_dest)).transfer(_reward);
        emit RewardSent(_dest, _reward, _id);
    }

    function refundToOwner() external onlyOwner {
        require(address(this).balance > 0, ""); // ⑭
        uint256 refundedBalance = address(this).balance;
        address(uint160(_owner)).transfer(refundedBalance);
        emit RefundedToOwner(msg.sender, refundedBalance);
    }
} */

/* 코드 6-10 */
pragma solidity >=0.4.22 <0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "./Activatable.sol"; // ①

// import "../06/openzeppelin/access/Ownable.sol";
// import "../06/openzeppelin/utils/Pausable.sol";
// import "./Activatable.sol";

// ②
contract Room is Ownable, Pausable, Activatable {
    address _owner = owner();

    mapping (uint256 => bool) public rewardSent;

    event Deposited(address indexed _depositor, uint256 _depositedValue);
    event RewardSent(address indexed _dest, uint256 _reward, uint256 _id);
    event RefundedToOwner(address indexed _dest, uint256 _refundedBalance);

    constructor(address _creator) payable {
        _owner = _creator;
    }

    function deposit() external payable whenNotPaused {
        require(msg.value > 0, "");
        emit Deposited(msg.sender, msg.value);
    }

    function sendReward(uint256 _reward, address _dest, uint256 _id) external onlyOwner {
        require(!rewardSent[_id], "");
        require(_reward > 0, "");
        require(address(this).balance >= _reward, "");
        require(_dest != _owner, "");

        rewardSent[_id] = true;
        address(uint160(_dest)).transfer(_reward);
        emit RewardSent(_dest, _reward, _id);
    }

    // ③
    function refundToOwner() external whenNotActive onlyOwner {
        require(address(this).balance > 0, "");
        uint256 refundedBalance = address(this).balance;
        address(uint160(_owner)).transfer(refundedBalance);
        emit RefundedToOwner(msg.sender, refundedBalance);
    }
}