import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const UserItemsModule = buildModule("UserItemsModule", (m) => {
  const userItems = m.contract("UserItems", []);

  return {
    userItems,
  };
});

export default UserItemsModule;
