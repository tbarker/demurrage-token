pragma solidity ^0.4.23;

import "./SimpleLedger.sol";

contract StorageFeeLedger is SimpleLedger {

    address public feeTokenAddress;
    uint128 public feeAmount;
    uint128 public blocksBetweenFee;
    address public feeEarningAccount;

    mapping(address => uint256) lastPaidBlock;
    mapping(address => uint256) feeDebt;

    constructor(address _feeTokenAddress, uint128 _feeAmount, uint128 _blocksBetweenFee, address _feeEarningAccount) public {
        feeTokenAddress = _feeTokenAddress;
        feeAmount = _feeAmount;
        blocksBetweenFee = _blocksBetweenFee;
        feeEarningAccount = _feeEarningAccount;
    }

    function _addTokens(address _address, uint256 change) internal {
        bool paidFee = payFee(_address);
        require((owner == msg.sender) || paidFee, "Cannot take fee.");
        super._addTokens(_address, change);
    }

    function _removeTokens(address _address, uint256 change) internal {
        bool paidFee = payFee(_address);
        require((owner == msg.sender) || paidFee, "Cannot take fee.");
        super._removeTokens(_address, change);
    }

    function feesAccured(address _address) public view returns (uint256) {
        uint256 periods = ((block.number - lastPaidBlock[_address]) / blocksBetweenFee);
        return periods * balanceOf(_address) * feeAmount;
    }

    function payFee(address _address) internal returns (bool) {
        ERC20 feeToken = ERC20(feeTokenAddress);

        uint256 due = feesAccured(_address) + feeDebt[_address];

        uint256 collectable = min(
            due,
            min(
                feeToken.balanceOf(feeEarningAccount),
                feeToken.allowance(_address, feeEarningAccount)
            )
        );

        feeToken.transferFrom(_address, feeEarningAccount, collectable);
        lastPaidBlock[_address] = block.number;

        uint256 residual = due.sub(collectable);

        if(0 == residual) {
            return true;
        } else {
            feeDebt[_address] = feeDebt[_address].add(residual);
            return false;
        }
    }
}