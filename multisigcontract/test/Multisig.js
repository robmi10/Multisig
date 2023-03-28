const { expect } = require("chai");

describe("Multisig", function () {
  let deployer, sig1, sig2, user;

  before(async function () {
    [deployer, sig1, sig2, user] = await ethers.getSigners();

    const MultiSigFactory = await ethers.getContractFactory(
      "contracts/Multisig.sol:MultiSig",
      deployer
    );

    this.MultiSigDeploy = await MultiSigFactory.deploy([sig1, sig2]);
  });
});
