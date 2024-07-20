import { ethers } from "hardhat";
import { OrganizationToken, OrganizationToken__factory, Vesting, Vesting__factory } from "../../typechain-types";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  // Deploy OrganizationToken
  const OrganizationTokenFactory: OrganizationToken__factory = await ethers.getContractFactory("OrganizationToken") as OrganizationToken__factory;
  const token: OrganizationToken = await OrganizationTokenFactory.deploy("OrgToken", "OTK", ethers.parseUnits("1000000", 18)) as OrganizationToken;
  await token.deployed();
  console.log("Token deployed to:", token.address);

  // Deploy Vesting Contract
//   const VestingFactory: Vesting__factory = await ethers.getContractFactory("Vesting") as Vesting__factory;
//   const vesting: Vesting = await VestingFactory.deploy(token.address) as Vesting;
//   await vesting.deployed();
//   console.log("Vesting contract deployed to:", vesting.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
