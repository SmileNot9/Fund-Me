// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {PriceConverterLib} from "./PriceConverterLib.sol";

contract FundMe {
    using PriceConverterLib for uint256;

    uint256 public minimumUSD = 5 * 1e18;
    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        // Allow users to send funds into the contract
        // Have a minimum ammout to sent
        // Return 18 decimals
        require(msg.value.getConversionRate() >= minimumUSD, "Didn't send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function withdraw() public onlyOwner {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the array
        funders = new address[](0);
        // 3 ways to withdraw: transfer, send, call
        /*
        payable(msg.sender).transfer(address(this).balance);
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");
        */
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Must be owner");
        _;
    }
}