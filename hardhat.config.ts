import type { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";
import { vars } from "hardhat/config";

const config: HardhatUserConfig = {
  solidity: "0.8.28",

  // Reference: https://hardhat.org/tutorial/deploying-to-a-live-network#_7-deploying-to-a-live-network
  networks: {
    polygon: {
      url: vars.get("POLYGON_RPC_URL"),
      accounts: [vars.get("DEFAULT_PRIVATE_KEY")],
    },
    base: {
      url: vars.get("BASE_RPC_URL"),
      accounts: [vars.get("DEFAULT_PRIVATE_KEY")],
    },
    bsc: {
      url: vars.get("BSC_RPC_URL"),
      accounts: [vars.get("DEFAULT_PRIVATE_KEY")],
    },
  },

  etherscan: {
    apiKey: {
      polygon: vars.get("POLYGONSCAN_API_KEY"),
      bsc: vars.get("BSCSCAN_API_KEY"),
      base: vars.get("BASESCAN_API_KEY"),
    },
  },
};

export default config;
