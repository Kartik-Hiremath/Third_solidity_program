// SPDX-License-Identifier: MIT
// TODO : 1. Set a min value and get the funds. 2. Withdraw.

pragma solidity ^0.8.20;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe{

    using PriceConverter for uint256;

    uint256 public minUsd = 2 * 1e18;
    address[] public funders;
    mapping(address funder => uint256 amount) public funderToAmountMap;
    address public ownerOfContract;

    constructor(){  // No need to mention public.
        ownerOfContract = msg.sender;
    }

    function fund() public payable{
        require(msg.value.getConversionRate() >= minUsd, "Ether amount not sufficient.Please send atleast $2 worth of ether.");
        funders.push(msg.sender);
        funderToAmountMap[msg.sender] = funderToAmountMap[msg.sender] + msg.value;
    }

    function withdraw() public ownerOnly {
        for(uint256 i=0; i<funders.length; i++){
            funderToAmountMap[funders[i]] = 0;
        }
        funders = new address[](0); // address array of length 0.
        // payable(msg.sender).transfer(address(this).balance);
        // bool transactionSuccess = payable(msg.sender).send(address(this).balance);
        (bool transactionSuccess, ) = payable(msg.sender).call{value : address(this).balance}("");
        require(transactionSuccess, "The Withdrawal Failed!");
    }

    modifier ownerOnly() {
        require(msg.sender == ownerOfContract, "You are not the owner of this contract.");
        _;  // This means continue the rest of the code.
    }
}