// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VolcanoCoin is Ownable {
    uint256 totalSuppyl = 10000;
    mapping(address=>uint256) public balances;

    struct Payment {
        uint amount;
        address recipient;
    }

    mapping(address=>Payment[]) public payments;

    event TotalSupplyUpdated(uint);
    event TokenTransfer(uint,address);
    constructor(){
        balances[owner()] = totalSuppyl;
    }

    function getTotalSupply() public view returns(uint256){
        return totalSuppyl;
    }

    function increaseTotalSupply() public onlyOwner{
        totalSuppyl += 1000;
        emit TotalSupplyUpdated(totalSuppyl);
    }
    
    function transfer(uint256 amount,address recipient) public{
        require(balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit TokenTransfer(amount,recipient);
    }

    function getPaymentsOfAnAddress(address target) public view returns(Payment[] memory){
        Payment[] memory personalPayments = payments[target];
        return  personalPayments;
    }

    function recordPayment(address sender, address receiver, uint256 amount) internal{
        Payment[] storage personalPayments = payments[sender];
        personalPayments.push(Payment(amount,receiver));
    }
}