export default async (promise) => {
  try {
    await promise;
    assert.fail('Expected fail not received');
  } catch (error) {
    const revertFound = error.message.search('assert.fail') >= 0;
    assert(revertFound, `Expected "assert.fail", got ${error} instead`);
  }
};
