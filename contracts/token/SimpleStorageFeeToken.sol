pragma solidity ^0.4.23;

import "./StorageFeeLedger.sol";
import "./LedgerToken.sol";

/// @title Token for which a storage fee is charged over time
contract SimpleStorageFeeToken is StorageFeeLedger, LedgerToken {
    constructor(address _feeTokenAddress, uint128 _feeAmount, uint64 _blocksBetweenFee, address _feeEarningAccount)
    StorageFeeLedger(_feeTokenAddress, _feeAmount, _blocksBetweenFee, _feeEarningAccount)
    public {}
}