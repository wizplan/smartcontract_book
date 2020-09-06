address payable x = msg.sender
address myAddress = address(this);
if (x.balance < 10 && myAddress.balance >= 10) x.transfer(10);