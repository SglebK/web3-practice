// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WarriorGuild {
    mapping(address => string) public warriorType;
    mapping(address => bool) public isRegistered;

    function register() public virtual {
        require(!isRegistered[msg.sender], "Already registered");
        isRegistered[msg.sender] = true;
        warriorType[msg.sender] = "Base Warrior";
    }

    function attack() public view virtual returns (string memory, uint256) {
        return ("Basic Punch", 10);
    }
}

contract Knight is WarriorGuild {
    function register() public override {
        super.register(); 
        warriorType[msg.sender] = "Knight";
    }

    function attack() public pure override returns (string memory, uint256) {
        return ("Sword Slash", 50);
    }
}

contract Mage is WarriorGuild {
    function register() public override {
        super.register();
        warriorType[msg.sender] = "Mage";
    }

    function attack() public pure override returns (string memory, uint256) {
        return ("Fireball", 70);
    }
}

contract Assassin is WarriorGuild {
    function register() public override {
        super.register();
        warriorType[msg.sender] = "Assassin";
    }

    function attack() public view override returns (string memory, uint256) {
        uint256 chance = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 100;
        
        if (chance < 30) {
            return ("Critical Backstab!", 100);
        } else {
            return ("Dagger Strike", 30);
        }
    }
}