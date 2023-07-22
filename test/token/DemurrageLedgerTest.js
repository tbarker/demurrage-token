const { wait } = require('@digix/tempo')(web3);

const DemurrageToken = artifacts.require('DemurrageToken');
const CommodityTokenRegister = artifacts.require('CommodityTokenRegister');
const CommodityToken = artifacts.require('CommodityToken');

contract('DemurrageLedger', (accounts) => {
  it('Should have an initial balance of 0', async () => {
    const ledger = await DemurrageToken.new(0);
    assert.equal((await ledger.totalSupply.call()).valueOf(), 0);
  });

  it('Add and remove tokens', async () => {
    const ledger = await DemurrageToken.new(0);
    await ledger.addTokens(accounts[0], 10);
    await ledger.removeTokens(accounts[0], 7);
    assert.equal((await ledger.balanceOf.call(accounts[0])).valueOf(), 3);
    assert.equal((await ledger.totalSupply.call()).valueOf(), 3);
  });

  it('Observe demurrage twice', async () => {
    const ledger = await DemurrageToken.new(0.5 * 1e27);
    await ledger.addTokens(accounts[0], 100);
    await ledger.addTokens(accounts[0], 0); // Cause mining
    assert.equal((await ledger.balanceOf.call(accounts[0])).valueOf(), 25);
    assert.equal((await ledger.totalSupply.call()).valueOf(), 25);
  });

  it('Check fidelity of real charges over an hour', async () => {
    const register = await CommodityTokenRegister.deployed();
    const riceAddress = await register.tokenOf.call('RICE');
    const ledger = CommodityToken.at(riceAddress);
    await ledger.addTokens(accounts[8], 1000000);
    await wait(0, 3600);
    assert.equal((await ledger.balanceOf.call(accounts[8])).valueOf(), 999989);
  });

  it('Minimal drift', async () => {
    const ledger = await DemurrageToken.new(0.04 * 1e27);

    await ledger.addTokens(accounts[0], 93442);
    await ledger.addTokens(accounts[1], 23423);
    await ledger.addTokens(accounts[2], 12321);
    await ledger.addTokens(accounts[0], 233245454);
    await ledger.addTokens(accounts[1], 123123);
    await ledger.addTokens(accounts[2], 9321);
    await ledger.addTokens(accounts[2], 88);
    await ledger.addTokens(accounts[0], 54);
    await ledger.addTokens(accounts[1], 98823423);

    assert.equal((await ledger.totalSupply.call()).valueOf()
      - (await ledger.balanceOf.call(accounts[0])).valueOf()
      - (await ledger.balanceOf.call(accounts[1])).valueOf()
      - (await ledger.balanceOf.call(accounts[2])).valueOf()
      < 4, true);
  });
});
