require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-foundry");

module.exports = {
  solidity: "0.8.24",
  networks: {
    fork: {
      "url": "http://127.0.0.1:8545",
      blockGasLimit: 100000000000
    }
  }
};