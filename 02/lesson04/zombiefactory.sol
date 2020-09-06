// 솔리디티 버전 지정
pragma solidity >=0.5.0 <0.6.0;

// 0.7.x 대응
// SPDX-License-Identifier: MIT
// pragma solidity >=0.5.0 <0.8.0;

import "./ownable.sol";

// 계약 정의
contract ZombieFactory is Ownable {
    // 이벤트 정의
    event NewZombie(uint zombieId, string name, uint dna);

    // 변수(uint 타입) 정의
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    // 구조체 구현
    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    // public 변수(Zombie 타입 배열) 정의
    Zombie[] public zombies;

    // 매핑 타입 변수 정의
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    // private 함수 구현
    function _createZombie(string memory _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;

        // 0.7.x 대응
        // zombies.push(Zombie(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0));
        // uint id = zombies.length - 1;

        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna); // 이벤트 실행
    }

    // private view 함수 구현
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    // public 함수 구현
    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0, "");
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }
}