const CommodityTokenRegister = artifacts.require('CommodityTokenRegister');
const CommodityToken = artifacts.require('CommodityToken');

contract('CommodityTokenRegister', () => {
  it('Transfer commodity-back token ownership success', async () => {
    const register = await CommodityTokenRegister.deployed();
    register.createToken('Test Onwership Token', 'TONER', 2.777777777777778e-09 * 1e27);
    const tokenContractAddress = await register.tokenOf.call('TONER');
    const tokenContract = CommodityToken.at(tokenContractAddress);
    assert.equal(await tokenContract.owner(), await register.owner());
  });
});
