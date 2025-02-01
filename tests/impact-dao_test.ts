import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Test proposal creation and voting",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const wallet1 = accounts.get("wallet_1")!;

    let block = chain.mineBlock([
      Tx.contractCall("impact-dao", "create-proposal", [
        types.ascii("Test Proposal"),
        types.utf8("Test Description"),
        types.uint(1),
        types.uint(1000)
      ], deployer.address),
      Tx.contractCall("impact-dao", "vote", [
        types.uint(0),
        types.bool(true)
      ], wallet1.address)
    ]);

    assertEquals(block.receipts.length, 2);
    assertEquals(block.height, 2);
  }
});
