const FiatToken = artifacts.require('FiatToken.sol');
const TokenController = artifacts.require('CommodityTokenController.sol');

module.exports = (deployer) => {
  deployer.deploy(FiatToken, 'Naira', 'NGN', TokenController.address);
};
