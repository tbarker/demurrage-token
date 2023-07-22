pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Ledger.sol";

/// @title List of balances, that all shrink.
/// @dev This works like a bank account in reverse.
contract DemurrageLedger is Ownable, Ledger {

    // Records the amount a balance was *previously*
    struct Entry {
        uint256 rayAmount;
        uint256 atBlock;
    }

    // An entry for the entire supply to avoid summing balances
    Entry issuance = Entry(0, 0);

    // Balances as entries, eg. the amount when last changed is recorded
    mapping(address => Entry) entries;

    // The fraction in Rays (see DSMath) lost each block
    // Check target blocktime for chain when setting this!
    uint256 demurragePerBlock;
 
    constructor(uint256 _demurragePerBlock) public {
        demurragePerBlock = _demurragePerBlock;
    }

    /// @dev Wraps internal addTokens, adding owner check
    function addTokens(address _address, uint256 _change) public onlyOwner {
        _addTokens(_address, _change);
    }

    /// @dev Adds tokens to the current balance, as calculated from the
    /// entry, and creates a new entry for the address to record the new
    /// balance.
    function _addTokens(address _address, uint256 _change) internal {
        uint256 rayChange = mul(_change, RAY);
        issuance = Entry(
            add(currentValue(issuance), rayChange),
            block.number
        );
        entries[_address] = Entry(
            add(currentValue(entries[_address]), rayChange),
            block.number
        );
    }

    /// @dev Wraps internal removeTokens, adding owner check
    function removeTokens(address _address, uint256 _change) public onlyOwner {
        _removeTokens(_address, _change);
    }

    /// @dev Like addTokens but in reverse
    function _removeTokens(address _address, uint256 _change) internal {
        uint256 rayChange = mul(_change, RAY);
        issuance = Entry(
            sub(currentValue(issuance), rayChange),
            block.number
        );
        entries[_address] = Entry(
            sub(currentValue(entries[_address]), rayChange),
            block.number
        );
    }

    function balanceOf(address _address) public view returns (uint256) {
        return currentValue(entries[_address]) / RAY;
    }

    function totalSupply() public view returns (uint256) {
        return currentValue(issuance) / RAY;
    }

    /// Calculates the present actual amount of a balance if it has
    /// not been manipulated since the time of the entry.
    function currentValue(Entry entry) internal view returns (uint256) {
        uint256 blocksPassed = sub(block.number, entry.atBlock); // First block is free
        uint256 rayFractionRetained = sub(RAY, demurragePerBlock);
        uint256 rayFractionRetainedOverPassedTime = rpow(rayFractionRetained, blocksPassed);
        return rmul(entry.rayAmount, rayFractionRetainedOverPassedTime);
    }
}