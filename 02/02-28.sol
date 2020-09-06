address payable withdrawAddress = 0x0cE446255506E92DF41614C46F1d6df9Cc969183;

uint withdrawValue = 0.05 ether;

withdrawAddress.transfer(withdrawValue);

/* withdrawAddress 변수를 address 타입으로 정의
address withdrawAddress = 0x0cE446255506E92DF41614C46F1d6df9Cc969183;

uint withdrawValue = 0.05 ether;

address(uint160(withdrawAddress)).transfer(withdrawValue); */