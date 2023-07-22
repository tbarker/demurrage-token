pragma solidity ^0.4.23;

import "../third-party/TokenController.sol";
import "../third-party/Controlled.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";


/// @title Token whom's transfers can be blocked by external logic
/// @dev Designed after OpenZeppelin's Pausable Tokens
contract ControllableToken is ERC20, Controlled {

    constructor(address _controller) public {
        controller = _controller;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(
            TokenController(controller).onTransfer(msg.sender, _to, _value),
            "Controller blocked transfer."
        );
        return super.transfer(_to, _value);
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(
            TokenController(controller).onTransfer(_from, _to, _value),
            "Controller blocked transferFrom."
        );
        return super.transferFrom(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        require(
            TokenController(controller).onApprove(msg.sender, _spender, _value),
            "Controller blocked approval."
        );
        return super.approve(_spender, _value);
    }

}