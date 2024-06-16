// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract Auction {

		function createAuction(uint256 itemNumber,uint256 startingPrice,uint256 duration) public { }

		function bid(uint256 itemNumber, uint256 bidAmount) public { }

		function checkAuctionActive(uint256 itemNumber) public returns (bool) { }

		function cancelAuction(uint256 itemNumber) public { }

		function timeLeft(uint256 itemNumber) public returns (uint256) { }

		function checkHighestBidder(uint256 itemNumber) public returns (address) { }

		function checkActiveBidPrice(uint256 itemNumber) public returns (uint256){ }

}