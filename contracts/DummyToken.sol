pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol";
import "openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";


contract DummyToken is PausableToken, DetailedERC20 {
    constructor() DetailedERC20("Token", "dummy", 18) public {
        balances[owner] = 10 ** (18 + 6 + 2); // 1e26
    }
}
