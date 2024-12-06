const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const token1 = m.contract("Token1", []);
  return { token1 };
});

// 0x5FbDB2315678afecb367f032d93F642f64180aa3