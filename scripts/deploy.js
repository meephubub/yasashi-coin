const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying with:", deployer.address);

  // Deploy SAM
  const Yasashi = await hre.ethers.getContractFactory("Yasashi");
  const Yasashi = await Yasashi.deploy(hre.ethers.utils.parseUnits("1000000", 18)); // 1M YSH
  await sam.deployed();
  console.log("SAM deployed at:", sam.address);

  // Deploy NFT (trustedSigner = deployer for now)
  const NFT = await hre.ethers.getContractFactory("MediaHashNFT");
  const nft = await NFT.deploy(deployer.address);
  await nft.deployed();
  console.log("NFT deployed at:", nft.address);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});