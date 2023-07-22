const TokenController = artifacts.require('CommodityTokenController.sol');
const CommodityTokenRegister = artifacts.require('CommodityTokenRegister.sol');

module.exports = (deployer) => {
  deployer.deploy(CommodityTokenRegister, TokenController.address);
};
