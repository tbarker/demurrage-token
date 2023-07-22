const TokenController = artifacts.require('CommodityTokenController.sol');
const DummyToken = artifacts.require('DummyToken.sol');

module.exports = (deployer) => {
  deployer.deploy(TokenController, DummyToken.address, 1e18);
};
