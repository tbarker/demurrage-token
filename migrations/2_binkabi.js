const DummyToken = artifacts.require('DummyToken.sol');

module.exports = (deployer) => {
  deployer.deploy(DummyToken);
};
