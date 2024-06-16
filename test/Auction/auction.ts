import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { loadFixture, time } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers, network } from "hardhat";

import { Signers } from "../types";
import { deployLockFixture } from "./auction.fixture";

describe("Auction", function () {
  before(async function () {
    this.signers = {} as Signers;

    const signers = await ethers.getSigners();
    this.signers.admin = signers[0];

    this.loadFixture = loadFixture;
  });

  describe("Auction Test", function () {
    beforeEach(async function () {
      const { auction,
        auction_address, owner, address1, address2, address3 } =
        await this.loadFixture(deployLockFixture);

      this.auction = auction;
      this.auction_address = auction_address;
      this.owner = owner;
      this.address1 = address1;
      this.address2 = address2;
      this.address3 = address3;
    });

    it("createAuction", async function () {
        const ethInWei = ethers.parseEther("10");

        await this.auction.connect(this.owner).createAuction(1, ethInWei, 100);
        await this.auction.connect(this.address1).checkAuctionActive(1).then((data: any) => {
            expect(data).to.equal(true);
        });
    });

    it("bid", async function() {
        const ethInWei = ethers.parseEther("11");
        await this.auction.connect(this.owner).createAuction(1, ethInWei, 100);
        await this.auction.connect(this.address1).bid(1, ethInWei, { value: ethInWei});

        await this.auction.connect(this.address1).checkHighestBidder(1).then((data: any) => {
            expect(this.address1).equals(data);
        });
    });

    it("cancelAuction", async function() {
        const ethInWei = ethers.parseEther("11");
        await this.auction.connect(this.owner).createAuction(1, ethInWei, 100);
        await this.auction.connect(this.address1).bid(1, ethInWei, { value: ethInWei});

        const address1BalanceBefore = await ethers.provider.getBalance(this.address1);

        await this.auction.connect(this.owner).cancelAuction(1);

        const address1BalanceAfter = await ethers.provider.getBalance(this.address1);

        expect(address1BalanceBefore).to.lessThan(address1BalanceAfter);
    });

    it("timeLeft", async function() {
        const ethInWei = ethers.parseEther("11");
        await this.auction.connect(this.owner).createAuction(1, ethInWei, 10000);

        const ethInWei1 = ethers.parseEther("11");
        await this.auction.connect(this.address1).bid(1, ethInWei1, { value: ethInWei1});

        const ethInWei2 = ethers.parseEther("12");
        await this.auction.connect(this.address1).bid(1, ethInWei2, { value: ethInWei2});

        await this.auction.connect(this.owner).timeLeft(1).then((data: any) => {
            expect(data).to.equal(166);
        });

    });
  });
});
