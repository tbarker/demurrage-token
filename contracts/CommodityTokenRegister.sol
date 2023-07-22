pragma solidity ^0.4.23;

import "./third-party/TokenController.sol";
import "./CommodityToken.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";


contract CommodityTokenRegister is Ownable {

    uint public defaultToExpiry = 30 days;

    address public tokenController;
    mapping(string => address) private tokens;

    constructor(address _tokenController) public {
        tokenController = _tokenController;
    }

    function createToken(string _name, string _ticker, uint256 _demurrageRate) public onlyOwner {
        CommodityToken token = new CommodityToken(_name, _ticker, defaultToExpiry, tokenController, _demurrageRate);
        token.transferOwnership(owner);
        tokens[_ticker] = token;
    }

    function tokenOf(string _ticker) public view returns (address) {
        return tokens[_ticker];
    }
}