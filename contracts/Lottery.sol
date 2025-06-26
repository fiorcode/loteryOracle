// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

contract Lottery {
    address public owner;
    address public oracle;
    address payable public winner;
    uint256 public price;
    uint256 public counter;
    mapping(uint => address) public player;

    constructor() {
        oracle = msg.sender;
    }

    modifier minAmount(uint256 value) {
        require(value == price, "Insuficietn funds.");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier onlyOracle() {
        require(msg.sender == oracle, "Only oracle can call this function.");
        _;
    }

    event VRF();

    function play() external payable minAmount(msg.value) {
        uint256 _counter = counter++;
        player[_counter] = msg.sender;
        if(_counter == 3) {
            // finish the game
            emit VRF();
        }
    }

    function setOracle(address _oracle) external onlyOwner() {
        oracle = _oracle;
    }

    function fullfilRandomness(uint256 randomNumber) external  {
        // This function would be called by the VRF provider
        // Logic to handle the random number and determine the winner
        address payable _winner;
        _winner = payable(address(player[randomNumber]));
        _winner.transfer(address(this).balance);
        winner = _winner;
    }
}
