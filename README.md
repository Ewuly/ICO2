# TD4_ICO

**Install Foundry & create a Forge project**  
curl -L https://foundry.paradigm.xyz | bash  
cargo install --git https://github.com/foundry-rs/foundry --profile local --locked forge cast chisel anvil  
  
**Create an ERC20 token contract**  
• Chose a ticker : ICO  
• Chose a total supply : 1 000 000  
• Chose a decimal number : 18  
  
**Implement all ERC20 functions (inherit from Open Zeppelin) :**    
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";  
  
**• Create a getToken() function which exchanges ETH tokens**  
// Exchange rate: 1 ETH = 10 Tokens  
function getToken() public payable onlyAllowed {  
  uint256 ethSent = msg.value;  
  uint256 tokensToMint = ethSent * 10;  
  uint256 tier = tierLevels[msg.sender];  
  tokensToMint *= tier; // Adjust tokens based on tier level  
  _mint(msg.sender, tokensToMint);  
  emit TokensExchanged(msg.sender, ethSent, tokensToMint);  
}  
  
**Create a script to deploy your contract(s)   
  • Migrate to Anvil**  
npm install @anvilabs/hardhat-plugin  
const { deployERC20WithAnvil } = require("@anvilabs/hardhat-plugin");  
  
**Implement customer allow listing  
• Create a mapping to track allowed users**  
mapping(address => bool) public allowedUsers;  
**• Create an admin function to add customers to allow list**  
function allowListUser(address user) public onlyOwner {  
  allowedUsers[user] = true;  
  emit AllowListed(user);  
}  
**• Create a modifier to allow only allowlisted users to call getToken()**  
modifier onlyAllowed() {  
  require(allowedUsers[msg.sender], "User not allowed");  
}  
  
**Implement multi level distribution  
• Differentiate levels of participation for users (tier 1, 2, 3)**  
function setTierLevel(address user, uint256 level) public onlyOwner {  
  require(level >= 1 && level <= 3, "Invalid tier level");  
  tierLevels[user] = level;  
  }  
**• Index quantity of tokens sent in getToken() on tier level**  
uint256 tier = tierLevels[msg.sender];  
tokensToMint *= tier; // Adjust tokens based on tier level  
  
**Implement air drop functions  
• Create a function to mint and send token to an arbitrary address, by admin**  
event TokensMintedAndSent(address to, uint256 amount);  
  
function airDropTokens(address recipient, uint256 amount) public onlyOwner {  
  uint256 decimals = decimals();  
  uint256 multiplicator = 10**decimals;  
  uint256 tokenAmount = amount * multiplicator;  
  _mint(recipient, tokenAmount);  
  emit TokensMintedAndSent(recipient, tokenAmount);  
    }  

**Deploy to a testnet
• Create an account on Infura (or Alchemy) and configure Forge**

**• Credit tokens to teacher**
## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
