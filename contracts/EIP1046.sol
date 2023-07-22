pragma solidity ^0.4.23;

/// @title ERC-20 optional metadata extension
interface TokenMetaData /* is ERC20 */ {

    /// @notice A distinct Uniform Resource Identifier (URI) for a given token.
    function tokenURI() external view returns (string);
}