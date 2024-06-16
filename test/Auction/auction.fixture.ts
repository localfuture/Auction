import { ethers } from "hardhat";

import type { Auction } from "../../types/contracts/Auction";
import type { Auction__factory } from "../../types/factories/contracts/Auction__factory";

export async function deployLockFixture() {
  const [owner, address1, address2, address3] = await ethers.getSigners();

  const Auction = (await ethers.getContractFactory("Auction")) as Auction__factory;
  const auction = (await Auction.deploy()) as Auction;
  const auction_address = await auction.getAddress();


  return {
    auction,
    auction_address,
    owner,
    address1,
    address2,
    address3
  };
}