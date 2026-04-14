// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUSD = 5 * 1e18;
    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable {
        // Allow users to send funds into the contract
        // Have a minimum ammout to sent
        // Return 18 decimals
        require(msg.value.getConversionRate() >= minimumUSD, "Didn't send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function withdraw() public {
        
    }
}