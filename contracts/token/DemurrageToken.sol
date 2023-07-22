pragma solidity ^0.4.23;

import "./DemurrageLedger.sol";
import "./LedgerToken.sol";

/// @title Token which falls in value over time
/// @dev Takes the demurrage ledger which does the falling in value bit,
/// and then wraps it in token functionality.
contract DemurrageToken is DemurrageLedger, LedgerToken {
    constructor(uint256 _demurragePerBlock)
    DemurrageLedger(_demurragePerBlock)
    public {}
}