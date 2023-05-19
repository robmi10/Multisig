const hre = require("hardhat");
const { ethers, deployments, network } = require("hardhat");

async function main() {
  // console.log("inside main deploy");
  await deployments.fixture(["all"]);
  multisigDeploy = await ethers.getContractFactory("Multisig");
  const multisig = await multisigDeploy.deploy(
    [
      "0x3E47A06eBA1C55fa6B30685cFc517336974Ecc27",
      "0x62d95F19dD724d0c0203d046A8ed7090d01FeD1b",
    ],
    2
  );
  console.log(
    `\n
     Multisig deployed at address --> [${multisig.address}]
     \n`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
