pragma solidity ^0.4.23;

import "./ExpiringERC20.sol";
import "./token/DemurrageToken.sol";
import "./token/ControllableToken.sol";
import "openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";

contract CommodityToken is DemurrageToken, ControllableToken, ExpiringERC20, DetailedERC20 {

    constructor(
        string _name,
        string _ticker,
        uint256 _expiresInMillis,
        address _controller,
        uint256 _demurrageRate
    )
    DetailedERC20(_name, _ticker, 3)
    ExpiringERC20(block.timestamp + _expiresInMillis)
    ControllableToken( _controller)
    DemurrageToken(_demurrageRate)
    public {}

}
