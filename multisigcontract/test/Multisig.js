const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Multisig", function () {
  let deployer, sig1, sig2, user, user2;
  let PRICE = ethers.utils.parseUnits("5");

  before(async function () {
    [deployer, sig1, sig2, user, user2] = await ethers.getSigners();

    const MultiSigFactory = await ethers.getContractFactory(
      "contracts/Multisig.sol:MultiSig",
      deployer
    );

    this.MultiSigDeploy = await MultiSigFactory.deploy(
      [sig1.address, sig2.address],
      2
    );
  });

  it("create", async function () {
    await this.MultiSigDeploy.connect(user).createTransaction(
      user2.address,
      PRICE,
      0x00
    );
    let txlist = await this.MultiSigDeploy.transactionList(0);
    expect(txlist);
  });

  it("vote", async function () {
    await this.MultiSigDeploy.connect(sig1).approve(0);
    await this.MultiSigDeploy.connect(sig2).approve(0);

    let balancBeforeUser2 = await ethers.provider.getBalance(user2.address);

    await this.MultiSigDeploy.connect(user).sendTx(0, {
      value: PRICE,
    });
    let balanceAfterUser2 = await ethers.provider.getBalance(user2.address);

    expect(balanceAfterUser2).to.be.equal(balancBeforeUser2.add(PRICE));
  });
});
