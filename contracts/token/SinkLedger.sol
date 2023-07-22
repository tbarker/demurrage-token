pragma solidity ^0.4.23;

import "./Ledger.sol";

/// @title List of balances, that is ownable, and who's balances drain into the owners account
/// @dev This wraps a demurrage token, so it has on the inside, a token which continually shrinks.
/// In this code, we do not need to consider why our inner token shrinks, it just happens.
///
/// Consider the case where the sink account cannot be credited or debited, it is simply the
/// the total shrinkage of the inner token. Since we do not know how (or if) the inner token shrinks
/// we need to store our own totalSupply variable and update it on add/removeTokens.
///
/// In this case...
///     sink account = demurrage loss = totalSupply - "inner" totalSupply
///
/// If we wish to manipulate the sink account, then we just have to store an offset so that...
///     sink account = demurrage loss + sink offset
///
/// Obviously this offset can, and often will be negative.
///
/// On each token add/remove, we check if it is the owner's account [which is the sink account],
/// if so, we validate the action against the calculated sink account balance. If valid, then the
/// the change is applied to the sink offset.
///
/// To use, have SinkLedger inherit from DemurrageLedger, and in turn be inherited by LedgerToken.
contract SinkLedger is Ledger {

    uint256 private _totalSupply;
    int256 private _sinkOffset;

}