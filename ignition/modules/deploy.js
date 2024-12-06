// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
  const rate =  10;
  const icoStart = 1733390140;
  const icoEnd = 1733391040;
  const Ico = m.contract("ICO", ["0xe055E3F21687ca6e735224a72A0860c71592Fb71","0x8eEdA3Bc5265ea2C7D827f932660f7F37B496148",rate,icoStart,icoEnd]);
  return { Ico };
});

// LockModule#Token1 - 0xe055E3F21687ca6e735224a72A0860c71592Fb71
// LockModule#Token2 - 0x8eEdA3Bc5265ea2C7D827f932660f7F37B496148
// LockModule#ICO - 0x3f914eA4ed40B43743bbE000218544324B20Ede7