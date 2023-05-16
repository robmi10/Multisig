const hre = require("hardhat");
const { ethers, deployments, network } = require("hardhat");

async function main() {
  console.log("inside main deploy");
  await deployments.fixture(["all"]);
  multisig = await ethers.getContract("MultiSig");

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
