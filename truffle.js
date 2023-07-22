require('babel-polyfill');
require('babel-register')({
  ignore: /node_modules\/(?!openzeppelin-solidity)/,
});

const TestRPC = require('ganache-cli');

module.exports = {
  networks: {
    development: {
      provider: TestRPC.provider(),
      network_id: '*', // Match any network id
    },
    local: {
      host: 'localhost',
      port: 8545,
      network_id: '*', // Match any network id
    },
    coverage: {
      host: 'localhost',
      port: 8555,
      gas: 0xfffffffffff,
      gasPrice: 0x01,
      network_id: '*', // Match any network id
    },
  },
};
