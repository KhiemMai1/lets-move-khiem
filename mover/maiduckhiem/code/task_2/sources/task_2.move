module task_2::my_coin {

    use std::option;
    use sui::coin::{Self,Coin,TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self,TxContext};

    public struct MY_COIN has drop {}

    fun init(witness: MY_COIN, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency(witness, 9, b"MY_COIN", b"MC", b"", option::none(), ctx);
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury, tx_context::sender(ctx))
    }

     public entry fun mint(treasury_cap: &mut TreasuryCap<MY_COIN>, amount: u64, recipient: address, ctx: &mut TxContext) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx);
    }

    public entry fun burn(treasury_cap: &mut TreasuryCap<MY_COIN>, coin : Coin<MY_COIN>, _ctx: &mut TxContext) {
        coin::burn(treasury_cap, coin);
    }
}