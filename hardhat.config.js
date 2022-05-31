require("@nomiclabs/hardhat-waffle");

const fs = require("fs");
const privateKey = fs.readFileSync(".secret").toString()

const projectId = "a94df2cc8d5a4a3d9f7984cb38892401"
module.exports = {
  networks: {
    hardhat: {
      chainId: 1337
    },
    mumbai: {
      url: 'https://polygon-mumbai.infura.io/v3/${projectId}',
      accounts: [privateKey]
    },
    mainnet: {
      url: 'https://polygon-mainnet.infura.io/v3/${projectId}',
      accounts: [privateKey]
    }
  },
  solidity: "0.8.4",
};
