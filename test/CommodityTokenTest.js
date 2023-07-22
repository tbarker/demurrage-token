import assertRevert from 'openzeppelin-solidity/test/helpers/assertRevert';
import expectAssertFail from './helpers/expectAssertFail';

const CommodityTokenController = artifacts.require('CommodityTokenController');
const CommodityToken = artifacts.require('CommodityToken');

contract('CommodityToken', (accounts) => {
  it('Should have an initial balance of 0', async () => {
    const token = await CommodityToken.new('Test', 'TEST', 8000, 0x00, 0);
    assert.equal((await token.balanceOf.call(accounts[0])).valueOf(), 0);
  });

  it('Add tokens', async () => {
    const controller = await CommodityTokenController.deployed();
    const token = await CommodityToken.new('Test', 'TEST', 8000, controller.address, 0);
    await token.addTokens(0x00, 100);
    assert.equal((await token.balanceOf.call(0x00)).valueOf(), 100);
  });

  it('Remove tokens', async () => {
    const controller = await CommodityTokenController.deployed();
    const token = await CommodityToken.new('Test', 'TEST', 8000, controller.address, 0);
    await token.addTokens(0x00, 100);
    await token.removeTokens(0x00, 97);
    assert.equal((await token.balanceOf.call(0x00)).valueOf(), 3);
  });

  it('Neither add nor remove tokens for non-owners', async () => {
    const controller = await CommodityTokenController.deployed();
    const token = await CommodityToken.new('Test', 'TEST', 8000, controller.address, 0);
    await assertRevert(token.addTokens(0x00, 1, { from: accounts[1] }));
    await assertRevert(token.removeTokens(0x00, 1, { from: accounts[1] }));
  });

  it('Does not transfer from a dummy non-holder', async () => {
    const controller = await CommodityTokenController.deployed();
    const token = await CommodityToken.new('Test', 'TEST', 8000, controller.address, 0);

    await token.addTokens(accounts[1], 1000);

    await expectAssertFail(token.transfer(accounts[0], 1, { from: accounts[1] }));
    await expectAssertFail(token.approve(accounts[0], 1, { from: accounts[1] }));
  });

  it('Does transfer from a dummy holder', async () => {
    const controller = await CommodityTokenController.deployed();
    const token = await CommodityToken.new('Test', 'TEST', 18000, controller.address, 0);

    await token.addTokens(accounts[0], 1000);
    assert.equal(true, await token.transfer.call(accounts[4], 1));
    assert.equal(true, await token.approve.call(accounts[4], 1));
  });

  it('Does transferFrom from a dummy holder', async () => {
    const controller = await CommodityTokenController.deployed();
    const token = await CommodityToken.new('Test', 'TEST', 18000, controller.address, 0);

    await token.addTokens(accounts[0], 10);
    await token.approve(accounts[4], 2);
    await token.transferFrom(accounts[0], accounts[4], 1, { from: accounts[4] });
    assert.equal((await token.balanceOf.call(accounts[4])).valueOf(), 1);
    assert.equal((await token.balanceOf.call(accounts[0])).valueOf(), 9);
    assert.equal((await token.allowance.call(accounts[0], accounts[4])).valueOf(), 1);
  });

  it('Does not transfer from a dummy holder if expired', async () => {
    const controller = await CommodityTokenController.deployed();
    const token = await CommodityToken.new('Test', 'TEST', 0, controller.address, 0);

    await token.addTokens(accounts[0], 100);
    await assertRevert(token.transfer.call(accounts[4], 1));
    await assertRevert(token.approve.call(accounts[4], 1));
  });

  it('Does not transfer from a dummy holder if whitelist enabled', async () => {
    const controller = await CommodityTokenController.deployed();
    const token = await CommodityToken.new('Test', 'TEST', 18000, controller.address, 0);

    await controller.setWhitelisting(true);

    await token.addTokens(accounts[0], 1000);
    await assertRevert(token.transfer.call(accounts[4], 1));
    await assertRevert(token.approve.call(accounts[4], 1));
  });

  it('Transfers from dummy holder if whitelisting enabled and whitelisted', async () => {
    const controller = await CommodityTokenController.deployed();
    const token = await CommodityToken.new('Test', 'TEST', 18000, controller.address, 0);

    await controller.setWhitelisting(true);
    await controller.addToWhitelist(accounts[0]);

    await token.addTokens(accounts[0], 1000);
    assert.equal(true, await token.transfer.call(accounts[4], 1));
    assert.equal(true, await token.approve.call(accounts[4], 1));
  });
});
