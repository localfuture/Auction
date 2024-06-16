// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract Auction {

    struct AuctionItem {
        uint itemNumber;
        uint stratingPrice;
        uint duration;
        address highestBidder;
        uint bid;
        bool active;
    }

    mapping(uint => AuctionItem) auctions;

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev This function allows the contract owner to create a new auction. 
     * The auction starts as soon as this function is called.
     * @param itemNumber the number of the item for auction and should be unique for each item
     * @param startingPrice the starting price of the auction in wei and cannot be zero
     * @param duration the duraction of the auction in seconds and cannot be zero
     */
	function createAuction(uint256 itemNumber,uint256 startingPrice,uint256 duration) public {
        require(owner == msg.sender);
        require(auctions[itemNumber].itemNumber == 0, "Unique");
        require(startingPrice > 0, "startingPrice must be a positive number");
        require(duration > 0, "duration must be a positive number");

        auctions[itemNumber].itemNumber = itemNumber;
        auctions[itemNumber].startingPrice = startingPrice;
        auctions[itemNumber].duration = block.timestamp + duration;
        auctions[itemNumber].active = true;
    }

    /**
     * @dev This is a payable function allows a user to place a bid on an item. 
     * @param itemNumber the number of the item for which the bid is being placed
     * @param bidAmount the amount of the bid
     */
	function bid(uint256 itemNumber, uint256 bidAmount) public payable { 
        AuctionItem storage auction = auctions[itemNumber];
        require(auction.active, "Auction is not active");
        require(block.timestamp < auction.duration, "Auction has ended");
        require(msg.value > auction.highestBid, "Bid must be higher than current highest bid");

        if (auction.highestBidder != address(0)) {
            auction.highestBidder.transfer(auction.highestBid); // Refund previous highest bidder
        }

        auction.highestBidder = payable(msg.sender);
        auction.highestBid = bidAmount;
    }

    /**
     * @dev This function allows the contract owner to cancel an auction. 
     * An auction can only be cancelled if the auction is still active.
     * @param itemNumber the number of the item for which the auction is being cancelled
     */
	function cancelAuction(uint256 itemNumber) public { 
        Auctions storage auction = auctions[itemNumber];
        require(auction.active, "Auction is not active");
        require(block.timestamp < auction.duration, "Auction has ended");

        auctions.active = false;

        if (auction.highestBidder != address(0)) {
            auction.highestBidder.transfer(auction.highestBid); // Refund previous highest bidder
        }
    }

    /**
     *  This function allows a user to check the status of an auction.
     * @param itemNumber the number of the item for which the auction status is being checked
     */
    function checkAuctionActive(uint256 itemNumber) public returns (bool) { 
        return auctions[itemNumber].active;
    }

    /**
     * This function returns the time left in seconds for the auction for the given item Number
     * @param itemNumber the number of the item
     * @return time left in seconds for the auction for the given item Number
     */
	function timeLeft(uint256 itemNumber) public returns (uint256) { 
        return (auctions[itemNumber].duration - block.timestamp) / 60;
    }

    /**
     * This function allows a user to check the highest bidder of an item.
     * @param itemNumber the number of the item for which the owner is being checked
     * @return address  highest bidder if the auction is active or has ended, or 
     * address 0 if the auction has not started or has been cancelled.
     */
	function checkHighestBidder(uint256 itemNumber) public returns (address) { 
        return auctions[itemNumber].highestBidder;
    }

    /**
     * This function returns the Highest bid price for the given item number if the auction is still active. 
     * f the auction has ended or has not started for the given item number then transaction should revert.
     * @param itemNumber the number of the item for which the owner is being checked
     * @return price highest bid price
     */
	function checkActiveBidPrice(uint256 itemNumber) public returns (uint256){ 
        return auctions[itemNumber].bid;
    }

}