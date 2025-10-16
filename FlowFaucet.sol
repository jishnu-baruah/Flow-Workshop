// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract FlowFaucet {
    address public owner;
    uint256 public dripAmount = 0.5 ether; // 0.5 FLOW per request
    uint256 public waitTime = 1 days;      // Daily limit

    // Track last request time per address
    mapping(address => uint256) public lastRequestTime;

    // Track all users who requested tokens
    address[] private users;

    // Events
    event TokensRequested(address indexed user, uint256 amount);
    event BalanceAdded(address indexed sender, uint256 amount);
    event DripAmountUpdated(uint256 newAmount);
    event WaitTimeUpdated(uint256 newWaitTime);
    event Withdrawn(address indexed owner, uint256 amount);
    event TimerReset(address indexed user);
    event AllTimersReset();

    constructor() payable {
        owner = msg.sender; // Deployer becomes owner
        // Optional: deploy with initial FLOW by sending value in Remix
    }

    // Anyone can request tokens once per day
    function requestTokens() public {
        require(address(this).balance >= dripAmount, "Faucet empty");
        require(
            block.timestamp - lastRequestTime[msg.sender] >= waitTime,
            "You can only request once per day"
        );

        // If first time requesting, add user to list
        if (lastRequestTime[msg.sender] == 0) {
            users.push(msg.sender);
        }

        lastRequestTime[msg.sender] = block.timestamp;
        payable(msg.sender).transfer(dripAmount);

        emit TokensRequested(msg.sender, dripAmount);
    }

    // Owner can refill faucet by sending FLOW via Value field
    function refill() public payable {
        require(msg.sender == owner, "Only owner can refill");
        require(msg.value > 0, "Send some FLOW to refill");
        emit BalanceAdded(msg.sender, msg.value);
    }

    // Owner can withdraw specific amount
    function withdraw(uint256 _amount) public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(_amount <= address(this).balance, "Not enough balance");
        payable(owner).transfer(_amount);

        emit Withdrawn(owner, _amount);
    }

    // Owner can withdraw entire balance
    function withdrawAll() public {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        payable(owner).transfer(balance);

        emit Withdrawn(owner, balance);
    }

    // Owner can reset a specific user's request timer
    function resetTimer(address _user) public {
        require(msg.sender == owner, "Only owner can reset timer");
        lastRequestTime[_user] = 0;

        emit TimerReset(_user);
    }

    // Owner can reset all users' timers
    function resetAllTimers() public {
        require(msg.sender == owner, "Only owner can reset timers");
        for (uint256 i = 0; i < users.length; i++) {
            lastRequestTime[users[i]] = 0;
        }
        emit AllTimersReset();
    }

    // Owner can adjust drip amount
    function setDripAmount(uint256 _amount) public {
        require(msg.sender == owner, "Only owner can set drip");
        dripAmount = _amount;
        emit DripAmountUpdated(_amount);
    }

    // Owner can adjust wait time
    function setWaitTime(uint256 _time) public {
        require(msg.sender == owner, "Only owner can set wait time");
        waitTime = _time;
        emit WaitTimeUpdated(_time);
    }

    // Allows contract to receive FLOW directly
    receive() external payable {
        emit BalanceAdded(msg.sender, msg.value);
    }
}
