pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

/**
 * @title Expiring Token
 * Prevents all ERC20 movements of the token wnen the chain's timestamp is
 * beyond the expiry.
 * @dev Modelled on the Open Zepplin Pausable Token.
 **/
contract ExpiringERC20 is ERC20 {

    uint256 public expires;

    constructor(uint256 _expires) public {
        expires = _expires;
    }

    modifier whenNotExpired {
        // @dev It is worth mentioning that this is vulnerable to miner manipulation.
        if (block.timestamp < expires) {
            _;
        } else {
            revert("Token is expired.");
        }
    }
    
    function transfer(address _to, uint256 _value) public whenNotExpired returns (bool) {
        return super.transfer(_to, _value);
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public whenNotExpired returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public whenNotExpired returns (bool) {
        return super.approve(_spender, _value);
    }

}
