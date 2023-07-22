pragma solidity ^0.4.23;

import "./token/ControllableToken.sol";
import "./token/SimpleLedger.sol";
import "./token/LedgerToken.sol";
import "openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";

contract FiatToken is ControllableToken, DetailedERC20, SimpleLedger, LedgerToken {

    constructor(
        string _name,
        string _ticker,
        address _controller
    )
    DetailedERC20(_name, _ticker, 3)
    ControllableToken( _controller)
    public {}

}
