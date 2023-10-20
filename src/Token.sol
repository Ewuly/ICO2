// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    mapping(address => bool) public allowedUsers;
    mapping(address => uint256) public tierLevels;

    event AllowListed(address user);
    event TokensMintedAndSent(address to, uint256 amount);
    event TokensExchanged(address user, uint256 ethSent, uint256 tokensReceived);
    event TokensDistributed(address recipient, uint256 amount, uint256 tierLevel);

    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        allowListUser(msg.sender);
        setTierLevel(msg.sender, 1);
    }

    function allowListUser(address user) public onlyOwner {
        allowedUsers[user] = true;
        emit AllowListed(user);
    }

    function setTierLevel(address user, uint256 level) public onlyOwner {
        require(level >= 1 && level <= 3, "Invalid tier level");
        tierLevels[user] = level;
    }

    function distributeTokens(
        address tokenReceiver,
        uint256 amount,
        uint256 tierLevel
    ) public onlyOwner {
        require(tierLevel >= 1 && tierLevel <= 3, "Invalid tier level");
        uint256 decimals = decimals();
        uint256 multiplicator = 10**decimals;
        uint256 tokenAmount = amount * multiplicator * tierLevel;
        _mint(tokenReceiver, tokenAmount);
        emit TokensDistributed(tokenReceiver, tokenAmount, tierLevel);
    }

    function getToken() public payable {
        require(allowedUsers[msg.sender], "User not allowed");
        uint256 ethSent = msg.value;
        uint256 tokensToMint = ethSent * 10; // Exchange rate: 1 ETH = 10 Tokens
        uint256 tier = tierLevels[msg.sender];
        tokensToMint *= tier; // Adjust tokens based on tier level
        _mint(msg.sender, tokensToMint);
        emit TokensExchanged(msg.sender, ethSent, tokensToMint);
    }

    function airDropTokens(address recipient, uint256 amount) public onlyOwner {
        uint256 decimals = decimals();
        uint256 multiplicator = 10**decimals;
        uint256 tokenAmount = amount * multiplicator;
        _mint(recipient, tokenAmount);
        emit TokensMintedAndSent(recipient, tokenAmount);
    }
}