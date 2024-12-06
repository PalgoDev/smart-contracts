import type { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";
import { vars } from "hardhat/config";

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  
  // Reference: https://hardhat.org/tutorial/deploying-to-a-live-network#_7-deploying-to-a-live-network
  networks: {
    polygon: {
      accounts: [vars.get("DEFAULT_PRIVATE_KEY")],
      url: vars.get("POLYGON_RPC_URL"),
    },
  },
};

export default config;
