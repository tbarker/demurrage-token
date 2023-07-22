const SimpleStorageFee = artifacts.require('SimpleStorageFeeToken.sol');
const FiatToken = artifacts.require('FiatToken.sol');

module.exports = (deployer, network, accounts) => {
  deployer.deploy(SimpleStorageFee, FiatToken.address, 1, 10, accounts[0]);
};
