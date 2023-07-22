const CommodityTokenRegister = artifacts.require('CommodityTokenRegister.sol');
const CommodityToken = artifacts.require('CommodityToken.sol');

/*
Rice = 0.00024 MT/day
Maize = 0.00024 MT/day
Soybean = 0.00013 MT/day
*/
const commodities = [
  ['MAIZE', 'Maize', 2.777777777777778e-09],
  ['RICE', 'Paddy Rice', 2.777777777777778e-09],
  ['SOY', 'Soybean', 1.5046296296296295e-09],
];

/* eslint-disable no-console,  no-restricted-syntax, no-await-in-loop */
module.exports = (deployer, network, accounts) => {
  deployer.then(async () => {
    const register = await CommodityTokenRegister.deployed();
    for (const commodity of commodities) {
      const ticker = commodity[0];
      const name = commodity[1];
      const demurrageRate = commodity[2];
      await register.createToken(name, ticker, demurrageRate * 1e27); // Convert to rays
      const addressOf = await register.tokenOf.call(ticker);
      console.log(`${ticker} [${name}] at ${addressOf}`);
      await CommodityToken.at(addressOf).addTokens(accounts[0], 1000);
      console.log(`Issued 1000 ${ticker}`);
    }
  });
};
