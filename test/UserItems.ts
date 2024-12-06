import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import { expect } from "chai";
import hre from "hardhat";
import { getAddress, parseEther } from "viem";

describe("UserItems", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployUserItemsFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await hre.viem.getWalletClients();

    const userItems = await hre.viem.deployContract("UserItems", []);

    const publicClient = await hre.viem.getPublicClient();

    return {
      userItems,
      owner,
      otherAccount,
      publicClient,
    };
  }

    describe("Minting", function (){
        it("Should mint an item", async function (){
            const { userItems, owner } = await loadFixture(deployUserItemsFixture);

            await userItems.write.mint([owner.account.address, BigInt(0), parseEther("400"), "0x00"]);

            const balance = await userItems.read.balanceOf([owner.account.address, BigInt(0)]);

            expect(balance).to.be.greaterThan(parseEther("400"));
        }
    })  

});
