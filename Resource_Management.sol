// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library ResourceUtils {
    function distributeEnergy(uint256 totalEnergy, uint256 splitCount) internal pure returns (uint256) {
        require(splitCount > 0, "Split count must be > 0");
        return totalEnergy / splitCount;
    }

    function calculateUpgradeCost(uint256 currentLevel, uint256 baseCost) internal pure returns (uint256) {
        return baseCost * (currentLevel + 1);
    }

    function optimizeGoldUsage(uint256 amount) internal pure returns (uint256) {
        if (amount > 1000) {
            return amount * 90 / 100; 
        }
        return amount;
    }
}

contract ResourceManager {
    using ResourceUtils for uint256;

    mapping(address => uint256) public gold;
    mapping(address => uint256) public energy;
    mapping(address => uint256) public buildingLevel;

    function addResources(uint256 _gold, uint256 _energy) public {
        gold[msg.sender] += _gold;
        energy[msg.sender] += _energy;
    }

    function splitEnergy(uint256 parts) public view returns (uint256) {
        return energy[msg.sender].distributeEnergy(parts);
    }

    function upgradeBuilding() public {
        uint256 currentLvl = buildingLevel[msg.sender];
        uint256 baseCost = 100;

        uint256 cost = currentLvl.calculateUpgradeCost(baseCost);
        uint256 finalCost = cost.optimizeGoldUsage();

        require(gold[msg.sender] >= finalCost, "Not enough gold");

        gold[msg.sender] -= finalCost;
        buildingLevel[msg.sender]++;
    }
}