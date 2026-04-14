// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice() internal view returns (uint256) {
        // Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI ✅
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        // Price of ETH in terms of USD
        // 2000.00000000 renturn 8 decimals
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer) * 1e10;
    }

    function getConversionRate(uint256 _ethAmount) internal view returns (uint256) {
        // 1 ETH?
        uint256 ethPrice = getPrice();
        // 2000_000000000000000000
        uint256 ethAmountInUsd = (ethPrice * _ethAmount) / 1e18;
        // (2000_000000000000000000 * 1_000000000000000000) / 1e18
        return ethAmountInUsd;
        // 2000_000000000000000000
    }

    function getVersion() internal view returns (uint256) {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version(); 
    }
}