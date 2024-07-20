// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vesting {
    address public admin;
    IERC20 public token;
    uint256 public totalVestingAmount;

    struct Stakeholder {
        address wallet;
        uint256 amount;
        uint256 releaseTime;
        bool claimed;
    }

    mapping(address => Stakeholder) public stakeholders;

    event TokensVested(address indexed stakeholder, uint256 amount, uint256 releaseTime);
    event TokensClaimed(address indexed stakeholder, uint256 amount);

    constructor(IERC20 _token) {
        admin = msg.sender;
        token = _token;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not an admin");
        _;
    }

    function addStakeholder(address _stakeholder, uint256 _amount, uint256 _releaseTime) external onlyAdmin {
        require(stakeholders[_stakeholder].wallet == address(0), "Stakeholder already exists");
        stakeholders[_stakeholder] = Stakeholder({
            wallet: _stakeholder,
            amount: _amount,
            releaseTime: _releaseTime,
            claimed: false
        });
        totalVestingAmount += _amount;
        emit TokensVested(_stakeholder, _amount, _releaseTime);
    }

    function claimTokens() external {
        Stakeholder storage stakeholder = stakeholders[msg.sender];
        require(stakeholder.wallet == msg.sender, "Not a stakeholder");
        require(block.timestamp >= stakeholder.releaseTime, "Tokens are still locked");
        require(!stakeholder.claimed, "Tokens already claimed");

        uint256 amount = stakeholder.amount;
        stakeholder.claimed = true;
        totalVestingAmount -= amount;
        require(token.transfer(msg.sender, amount), "Token transfer failed");
        emit TokensClaimed(msg.sender, amount);
    }

    function withdraw() external onlyAdmin {
        uint256 balance = token.balanceOf(address(this));
        require(balance > totalVestingAmount, "Insufficient balance to withdraw");
        uint256 amountToWithdraw = balance - totalVestingAmount;
        require(token.transfer(admin, amountToWithdraw), "Token transfer failed");
    }
}
