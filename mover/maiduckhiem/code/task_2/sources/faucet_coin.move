module task_2::faucet_coin {
    use sui::coin::{Self,Coin,TreasuryCap};
    use std::option::{Self,some};
    use sui::transfer;
    use sui::tx_context::{Self,TxContext};
    use sui::url;
    use std::string;

    public struct FAUCET_COIN has drop {}

    fun init(witness: FAUCET_COIN, ctx: &mut TxContext) {
        let _url = string::to_ascii(string::utf8(b"https://pixabay.com/zh/vectors/bitcoin-logo-digital-money-910307"));
        let (treasury, metadata) = coin::create_currency(witness, 9, b"FAUCET_COIN", b"FAUC", b"", some(url::new_unsafe(_url)), ctx);
        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury);
    }

     public entry fun mint(treasury_cap: &mut TreasuryCap<FAUCET_COIN>, amount: u64, recipient: address, ctx: &mut TxContext) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx);
    }

    public entry fun burn(treasury_cap: &mut TreasuryCap<FAUCET_COIN>, coin : Coin<FAUCET_COIN>, _ctx: &mut TxContext) {
        coin::burn(treasury_cap, coin);
    }
}
