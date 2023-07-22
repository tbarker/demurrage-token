pragma solidity ^0.4.23;

import "../third-party/math.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

/// @title List of balances, nothing more.
contract Ledger is DSMath, ERC20 {
    function _addTokens(address _address, uint256 change) internal;
    function _removeTokens(address _address, uint256 change) internal;

    function addTokens(address _address, uint256 change) public;
    function removeTokens(address _address, uint256 change) public;

    function balanceOf(address _address) public view returns (uint256);
    function totalSupply() public view returns (uint256);
}