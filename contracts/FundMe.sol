// SPDX-License-Identifier: MIT
// TODO : 1. Set a min value and get the funds. 2. Withdraw. 3. Optimize.

pragma solidity ^0.8.20;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe{

    using PriceConverter for uint256;

    uint256 public constant MIN_USD = 2 * 1e18;
    address[] public funders;
    mapping(address funder => uint256 amount) public funderToAmountMap;
    address public immutable i_OwnerOfContract;

    constructor(){
        i_OwnerOfContract = msg.sender;
    }

    function fund() public payable{
        require(msg.value.getConversionRate() >= MIN_USD, "Ether amount not sufficient.Please send atleast $2 worth of ether.");    //msg.value is the first parameter of the function getConversionRate.
        funders.push(msg.sender);
        funderToAmountMap[msg.sender] = funderToAmountMap[msg.sender] + msg.value;
    }

    function withdraw() public ownerOnly {
        for(uint256 i=0; i<funders.length; i++)
            funderToAmountMap[funders[i]] = 0;
        funders = new address[](0); // address array of length 0.
        // payable(msg.sender).transfer(address(this).balance);
        // bool transactionSuccess = payable(msg.sender).send(address(this).balance);
        (bool transactionSuccess, ) = payable(msg.sender).call{value : address(this).balance}("");
        require(transactionSuccess, "The Withdrawal Failed!");
    }

    modifier ownerOnly() {
        // require(msg.sender == i_OwnerOfContract, "You are not the owner of this contract.");
        // require(msg.sender == i_OwnerOfContract, NotOwner());
        if(msg.sender != i_OwnerOfContract)
            revert NotOwner();
        _;  // This means continue the rest of the code.
    }
}

/* NOTE :
    1. Initially the contract costs : 595855 gas, after using constant: 575550 gas, after using immutable: 553047
    2. MIN_USD call : 2400 gas to 300 gas after using constant.
    3. For the constructor no need to specify public.
*/
