import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Ensure can add valid review",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall(
        "reviews",
        "add-review",
        [
          types.uint(1),
          types.uint(5),
          types.utf8("Great product!")
        ],
        wallet_1.address
      )
    ]);
    
    assertEquals(block.receipts[0].result, '(ok true)');
  },
});

Clarinet.test({
  name: "Ensure cannot add duplicate review",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall(
        "reviews",
        "add-review",
        [
          types.uint(1),
          types.uint(5),
          types.utf8("First review")
        ],
        wallet_1.address
      ),
      Tx.contractCall(
        "reviews",
        "add-review",
        [
          types.uint(1),
          types.uint(4),
          types.utf8("Duplicate review")
        ],
        wallet_1.address
      )
    ]);
    
    assertEquals(block.receipts[1].result, '(err u302)');
  },
});
