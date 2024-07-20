// import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import { HardhatUserConfig } from "hardhat/types";
// import "@nomiclabs/hardhat-waffle";
// import "@nomiclabs/hardhat-ethers";
// import "hardhat-typechain";
;
require("dotenv").config({ path: ".env" });

const INFURA_SEPOLIA_API_KEY_URL = process.env.INFURA_SEPOLIA_API_KEY_URL;

const ACCOUNT_PRIVATE_KEY = process.env.ACCOUNT_PRIVATE_KEY;

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url:
        INFURA_SEPOLIA_API_KEY_URL,
      accounts: [ACCOUNT_PRIVATE_KEY || ""] ,
    },
  },
};

export default config;
