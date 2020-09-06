// 수정 필요

// 솔리디티 버전 지정
pragma solidity >=0.5.0 <0.6.0;

// 솔리디티 0.7.x 대응
// SPDX-License-Identifier: MIT
// pragma solidity >=0.5.0 <0.8.0;

// 계약 정의
contract ZombieFactory {
    // 이벤트 정의
    event NewZombie(uint zombieId, string name, uint dna);

    // 변수(uint 타입) 정의
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    // 구조체 구현
    struct Zombie {
        string name;
        uint dna;
    }

    // public 변수(Zombie 타입 배열) 정의
    Zombie[] public zombies;

    // private 함수 구현
    function _createZombie(string memory _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;

        // 솔리디티 0.7.x 대응
        // zombies.push(Zombie(_name, _dna));
        // uint id = zombies.length - 1;

        emit NewZombie(id, _name, _dna);
    }

    // private view 함수 구현
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    // public 함수 구현
    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}