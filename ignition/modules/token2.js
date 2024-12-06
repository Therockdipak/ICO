const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
    const token2 = m.contract("Token2", []);
    return { token2 };
  });