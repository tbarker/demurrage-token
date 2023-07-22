pragma solidity ^0.4.23;

import "./Ledger.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract SimpleLedger is Ledger, Ownable {

    using SafeMath for uint256;

    mapping(address => uint256) private balances;

    uint256 private _totalSupply;

    function _addTokens(address _address, uint256 change) internal {
        balances[_address] = balances[_address].add(change);
    }

    function _removeTokens(address _address, uint256 change) internal {
        balances[_address] = balances[_address].sub(change);
    }

    /// @dev Wraps internal addTokens, adding owner check
    function addTokens(address _address, uint256 _change) public onlyOwner {
        _addTokens(_address, _change);
    }
    
    /// @dev Wraps internal removeTokens, adding owner check
    function removeTokens(address _address, uint256 _change) public onlyOwner {
        _removeTokens(_address, _change);
    }

    /**
    * @dev total number of tokens in existence
    */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

}