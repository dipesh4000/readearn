const hre = require("hardhat");

async function main() {
  const ResearchPlatform = await hre.ethers.getContractFactory("ResearchPlatform");
  const researchPlatform = await ResearchPlatform.deploy();

  await researchPlatform.deployed();

  console.log("ResearchPlatform deployed to:", researchPlatform.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
