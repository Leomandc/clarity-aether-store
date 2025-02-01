import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Ensure can list valid product",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall(
        "product",
        "list-product",
        [
          types.utf8("Test Product"),
          types.utf8("Test Description"),
          types.uint(1000000),
          types.uint(10)
        ],
        wallet_1.address
      )
    ]);
    
    assertEquals(block.receipts[0].result, '(ok u0)');
  },
});
