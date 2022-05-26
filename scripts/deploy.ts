import { ethers } from "hardhat";

async function main() {
  const BlockHeightReader = await ethers.getContractFactory("BlockHeightReader");
  const reader = await BlockHeightReader.deploy();

  await reader.deployed();

  console.log("BlockHeightReader deployed to:", reader.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
