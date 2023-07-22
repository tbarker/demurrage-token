pragma solidity ^0.4.23;

import "./third-party/TokenController.sol";
import "./token/LedgerToken.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";


/// @dev The token controller contract must implement these functions
contract CommodityTokenController is TokenController, Ownable {

    address public dummy_token;
    uint256 public token_needed;

    bool public whitelistingEnabled;
    mapping (address=>bool) public whitelist;

    constructor(
        address _dummy_token,
        uint8 _token_needed
    ) public
    {
        dummy_token = _dummy_token;
        token_needed = _token_needed;
    }

    function proxyPayment(address _owner) public payable returns(bool) {
        return true;
    }

    function onTransfer(address _from, address _to, uint _amount) public returns(bool) {
        return isAllowed(_from);
    }

    function onApprove(address _owner, address _spender, uint _amount) public
        returns(bool) {
        return isAllowed(_owner);
    }

    function addToWhitelist(address _addressToAdd) public onlyOwner {
        whitelist[_addressToAdd] = true;
    }

    function removeFromWhitelist(address _addressToRemove) public onlyOwner {
        require(whitelist[_addressToRemove], "Address not whitelisted.");
        whitelist[_addressToRemove] = false;
    }

    function setWhitelisting(bool _whitelistingStatus) public onlyOwner {
        whitelistingEnabled = _whitelistingStatus;
    }

    function isAllowed(address _address) internal returns (bool) {
        return
            token_needed <= ERC20(dummy_token).balanceOf(_address) &&
            ( !whitelistingEnabled || whitelist[_address] );
    }
}
