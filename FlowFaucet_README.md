
# FlowFaucet Contract

**Deployed Address:** `0x5c5c6D0343D8B4435f12CB313bb489DB1E49b41B`  

**Solidity Version:** `0.8.20`  
**License:** MIT  

A simple **Faucet contract** for distributing FLOW tokens (or Ether) with rate-limiting, owner controls, and demo functionality.

---

## Features

- **Request Tokens:** Users can request a fixed amount of FLOW (`dripAmount`) once per `waitTime`.  
- **Owner Controls:**  
  - Refill the faucet with FLOW (`refill()`)  
  - Withdraw specific or all balance (`withdraw(_amount)` / `withdrawAll()`)  
  - Adjust drip amount (`setDripAmount(uint256 _amount)`)  
  - Adjust wait time between requests (`setWaitTime(uint256 _time)`)  
  - Reset a single user’s timer (`resetTimer(address _user)`)  
  - Reset all users’ timers (`resetAllTimers()`)  
- **Receive FLOW:** Contract can accept FLOW via direct transfer.  
- **Demo-ready:** Can simulate adding FLOW for testing.

---

## Contract Functions

### User Functions

| Function | Description |
|----------|-------------|
| `requestTokens()` | Request `dripAmount` of FLOW. Can only be called once per `waitTime` per user. |

### Owner Functions

| Function | Description |
|----------|-------------|
| `refill()` | Add FLOW to the faucet. Send value in Remix or via transaction. |
| `withdraw(uint256 _amount)` | Withdraw a specific amount from the faucet. |
| `withdrawAll()` | Withdraw the entire contract balance. |
| `setDripAmount(uint256 _amount)` | Set the amount each user receives per request. Input in **wei** or use `ether` suffix in Remix. |
| `setWaitTime(uint256 _time)` | Set the minimum wait time (in seconds) between requests. |
| `resetTimer(address _user)` | Reset a specific user’s request timer. |
| `resetAllTimers()` | Reset request timers for all users who have requested tokens. |

### Other Functions

| Function | Description |
|----------|-------------|
| `receive()` | Allows the contract to accept FLOW via direct transfer. |

---

## Usage Examples

### Request Tokens
```solidity
flowFaucet.requestTokens();
```

### Owner: Refill Faucet
- In Remix, select the `refill()` function  
- Enter a **Value** (e.g., `1 ether`)  
- Click **Transact**  

### Owner: Set Drip Amount
```solidity
flowFaucet.setDripAmount(2 ether); // Set drip to 2 FLOW
```

### Owner: Withdraw Tokens
```solidity
flowFaucet.withdraw(1 ether); // Withdraw 1 FLOW
flowFaucet.withdrawAll();     // Withdraw entire balance
```

### Owner: Reset Timers
```solidity
flowFaucet.resetTimer(userAddress); // Reset specific user
flowFaucet.resetAllTimers();        // Reset all users
```

---

## Notes
- **1 FLOW = 1 ether in Remix JS VM**  
- **All amounts in Solidity functions are in wei**. Use `ether` suffix for readability.  
- `lastRequestTime` mapping tracks user timers. Users must wait `waitTime` between requests unless reset by the owner.  

---

## Events
- `TokensRequested(address user, uint256 amount)`  
- `BalanceAdded(address sender, uint256 amount)`  
- `DripAmountUpdated(uint256 newAmount)`  
- `WaitTimeUpdated(uint256 newWaitTime)`  
- `Withdrawn(address owner, uint256 amount)`  
- `TimerReset(address user)`  
- `AllTimersReset()`  
