// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {PriceConverterLib} from "./PriceConverterLib.sol";

error NotOwner();
error NotEnoughETH();
error InsufficientBalance();
error CallFailed();

contract FundMe {
    using PriceConverterLib for uint256;

    uint256 public constant MINIMUM_USD = 5 * 1e18;
    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // Allow users to send funds into the contract
        // Have a minimum ammout to sent
        // Return 18 decimals
        if(msg.value.getConversionRate() < MINIMUM_USD) {revert NotEnoughETH();}
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw(uint256 _withdrawAmount) public onlyOwner {
        uint256 balance = addressToAmountFunded[msg.sender];
        if(balance < _withdrawAmount) {revert InsufficientBalance();}
        addressToAmountFunded[msg.sender] -= _withdrawAmount;
        /*
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the array
        funders = new address[](0);
        */
        // 3 ways to withdraw: transfer, send, call
        /*
        payable(msg.sender).transfer(address(this).balance);
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");
        */
        (bool callSuccess,) = payable(msg.sender).call{value: _withdrawAmount}("");
        if(!callSuccess) {revert CallFailed();}
    }
    
    modifier onlyOwner() {
        /* Less gas efficient method ↓↓↓
        require(msg.sender == i_owner, "Must be owner");
        */
        if(msg.sender != i_owner) {revert NotOwner();}
        _;
    }
}