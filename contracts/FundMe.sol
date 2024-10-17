// SPDX-License-Identifier: MIT
// TODO : 1. Set a min value and get the funds. 2. Withdraw.

pragma solidity ^0.8.20;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe{

    using PriceConverter for uint256;

    uint256 minUsd = 5 * 1e18;
    address[] public funders;
    mapping(address funder => uint256 amount) funderToAmountMap;

    function fund() public payable{
        require(msg.value.getConversionRate() >= minUsd, "Ether amount not sufficient.Please send atleast $5 worth of ether.");
        funders.push(msg.sender);
        funderToAmountMap[msg.sender] = funderToAmountMap[msg.sender] + msg.value;
    }

}