// SPDX-License-Identifier: MIT
// TODO : 1. Set a min value and get the funds. 2. Withdraw.

pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe{

    uint256 minUsd = 5 * 1e18;
    address[] public funders;
    mapping(address funder => uint256 amount) funderToAmountMap;

    function fund() public payable{
        require(convertion(msg.value) >= minUsd, "Ether amount not sufficient.Please send atleast $5 worth of ether.");
        funders.push(msg.sender);
        funderToAmountMap[msg.sender] = funderToAmountMap[msg.sender] + msg.value;
    }

    function getPrice() public view returns(uint256) {
        // Address (ETH to USD) : 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI : AggregatorV3Interface gives the necessary functions.
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function convertion(uint256 _amount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethToUsd = (_amount * ethPrice) / 1e18;
        return ethToUsd;
    }

    function getVersion() public view returns(uint256, uint8) {
        AggregatorV3Interface obj = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return (obj.version(), obj.decimals());
    }
}