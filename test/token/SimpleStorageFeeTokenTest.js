import assertRevert from 'openzeppelin-solidity/test/helpers/assertRevert';

const { wait } = require('@digix/tempo')(web3);

const SimpleStorageFeeToken = artifacts.require('SimpleStorageFeeToken');
const DummyToken = artifacts.require('DummyToken.sol');

contract('SimpleStorageFeeToken', (accounts) => {
  it('Should have an initial balance of 0', async () => {
    const ledger = await SimpleStorageFeeToken.deployed();
    assert.equal((await ledger.totalSupply.call()).valueOf(), 0);
  });

  it('Not accure fees by block 6', async () => {
    const ledger = await SimpleStorageFeeToken.deployed();
    await ledger.addTokens(0x00, 100);
    await wait(0, 6);
    assert.equal((await ledger.feesAccured.call(0x00)).valueOf(), 0);
  });

  it('200 accured fees by block 20', async () => {
    const ledger = await SimpleStorageFeeToken.deployed();
    await ledger.addTokens(0x01, 100);
    await wait(0, 20);
    assert.equal((await ledger.feesAccured.call(0x01)).valueOf(), 200);
  });

  it('400 accured fees by block 40, then cleared', async () => {
    const ledger = await SimpleStorageFeeToken.deployed();
    const dummy = await DummyToken.deployed();
    await dummy.approve(SimpleStorageFeeToken.address, 0);
    await ledger.addTokens(accounts[0], 100);
    await wait(0, 40);
    assert.equal((await ledger.feesAccured.call(accounts[0])).valueOf(), 400);
    await dummy.approve(SimpleStorageFeeToken.address, 1000000);
    await ledger.removeTokens(accounts[0], 100);
    assert.equal((await ledger.feesAccured.call(accounts[0])).valueOf(), 0);
  });

  it('Needs an approval or fail to take fees - if not token owner', async () => {
    const ledger = await SimpleStorageFeeToken.deployed();
    const dummy = await DummyToken.deployed();
    await dummy.transfer(accounts[1], 5000);
    await ledger.addTokens(accounts[1], 100);
    await wait(0, 40);
    await dummy.approve(SimpleStorageFeeToken.address, 0, { from: accounts[1] });
    assertRevert(ledger.transfer(accounts[2], 100, { from: accounts[1] }));
    await dummy.approve(SimpleStorageFeeToken.address, 1000000, { from: accounts[1] });
    await ledger.removeTokens(accounts[1], 1);
    assert.equal((await ledger.feesAccured.call(accounts[1])).valueOf(), 0);
    await dummy.approve(SimpleStorageFeeToken.address, 0, { from: accounts[1] });
    await ledger.removeTokens(accounts[1], 1);
  });
});
