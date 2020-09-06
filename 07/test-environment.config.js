module.exports = {
  accounts: {
    amount: 10, // 계정 잠금을 해제한 계정 숫자
    ether: 100, // 잠금 해제한 계정의 초기 잔액 설정(ether 단위)
  },

  contracts: {
    type: 'truffle', // 사용할 계약 추상화
    defaultGas: 6e6, // 최대 가스양
  },

  blockGasLimit: 8e6, // 블록당 최대 가스양
};