pragma solidity ^0.4.23;

import "./Ledger.sol";
import "../third-party/math.sol";

/// @title Token which falls in value over time
/// @dev Mostly plaguarised from OpenZeppelin's Basic and Standard Tokens
contract LedgerToken is Ledger {

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping (address => mapping (address => uint256)) internal allowed;

    /**
    * @dev Function to check the amount of tokens that an owner allowed to a spender.
    * @param _owner address The address which owns the funds.
    * @param _spender address The address which will spend the funds.
    * @return A uint256 specifying the amount of tokens still available for the spender.
    */
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "Cannot send to 0x00");
        require(_value <= balanceOf(_from), "Insufficient token balance.");
        require(_value <= allowed[_from][msg.sender], "Insufficient token allowance.");

        _removeTokens(_from, _value);
        _addTokens(_to, _value);
        allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);

        emit Transfer(_from, _to, _value);
        return true;
    }

    /**
    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
    *
    * Beware that changing an allowance with this method brings the risk that someone may use both the old
    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    * @param _spender The address which will spend the funds.
    * @param _value The amount of tokens to be spent.
    */
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
    * @dev transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "Cannot send to 0x00");
        require(_value <= balanceOf(msg.sender), "Insufficient token balance.");

        _removeTokens(msg.sender, _value);
        _addTokens(_to, _value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
}