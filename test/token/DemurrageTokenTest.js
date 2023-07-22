const DemurrageToken = artifacts.require('DemurrageToken');

contract('DemurrageToken', () => {
  it('Should have an initial balance of 0', async () => {
    const ledger = await DemurrageToken.new(0);
    assert.equal((await ledger.totalSupply.call()).valueOf(), 0);
  });
});
