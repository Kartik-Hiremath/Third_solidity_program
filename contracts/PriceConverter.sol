//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{

    function getPrice() public view returns(uint256) {
        // Address (ETH to USD) : 0x694AA1769357215DE4FAC081bf1f309aDC325306 for Sapolia OR 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF for zkSync.
        // ABI : AggregatorV3Interface gives the necessary functions.
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
        (,int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 _amount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethToUsd = (_amount * ethPrice) / 1e18;
        return ethToUsd;
    }

}