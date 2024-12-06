require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: "https://sepolia.infura.io/v3/8312614cac8d408593279cfcbf4bee0d",
      accounts: [process.env.PRIVATE_KEY], 
    }
  }
};
