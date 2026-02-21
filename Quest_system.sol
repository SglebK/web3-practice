// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IQuest {
    function startQuest(uint256 questId) external;
    function completeQuest(uint256 questId) external;
    function getReward(uint256 questId) external;
}

contract QuestManager is IQuest {
    struct Quest {
        string name;
        uint256 rewardAmount;
        uint256 xpReward;
        bool isActive;
    }

    struct Player {
        uint256 level;
        uint256 xp;
        uint256 balance;
        mapping(uint256 => bool) hasStarted;
        mapping(uint256 => bool) hasCompleted;
    }

    mapping(uint256 => Quest) public quests;
    mapping(address => Player) public players;
    uint256 public nextQuestId;

    function createQuest(string memory _name, uint256 _reward, uint256 _xp) public {
        quests[nextQuestId] = Quest(_name, _reward, _xp, true);
        nextQuestId++;
    }

    function startQuest(uint256 questId) external override {
        require(quests[questId].isActive, "Quest not active");
        require(!players[msg.sender].hasStarted[questId], "Already started");
        
        players[msg.sender].hasStarted[questId] = true;
    }

    function completeQuest(uint256 questId) external override {
        require(players[msg.sender].hasStarted[questId], "Quest not started");
        require(!players[msg.sender].hasCompleted[questId], "Already completed");

        players[msg.sender].hasCompleted[questId] = true;
        getReward(questId);
    }

    function getReward(uint256 questId) public override {
        require(players[msg.sender].hasCompleted[questId], "Quest not completed");
        
        Quest memory q = quests[questId];
        players[msg.sender].balance += q.rewardAmount;
        players[msg.sender].xp += q.xpReward;

        checkLevelUp(msg.sender);
    }

    function checkLevelUp(address _player) internal {
        uint256 requiredXp = players[_player].level * 100 + 100;
        if (players[_player].xp >= requiredXp) {
            players[_player].level++;
            players[_player].xp -= requiredXp;
        }
    }
    
    function getPlayerStats(address _player) public view returns (uint256, uint256, uint256) {
        return (players[_player].level, players[_player].xp, players[_player].balance);
    }
}