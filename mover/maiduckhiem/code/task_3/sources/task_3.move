module task_3::MY_NFT {
    use sui::url::{Self, Url};
    use std::string;
    use sui::object::{Self, ID, UID};
    use sui::event;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    /// An example that allows anyone to mint NFTs
    public struct DevNetNFT has key, store {
        id: UID,
        name: string::String,
        description: string::String,
        url: Url,
        // TODO: allow custom attributes 
    }
    // ===== Events =====
    public struct NFTMinted has copy, drop {
        object_id: ID,
        creator: address,
        name: string::String,
    }
    /// Get the NFT's name
    public fun name(nft: &DevNetNFT): &string::String {
        &nft.name
    }
    /// Get the NFT's description
    public fun description(nft: &DevNetNFT): &string::String {
        &nft.description
    }
    /// Get the NFT's URL
    public fun url(nft: &DevNetNFT): &Url {
        &nft.url
    }
    /// Create a new NFT
    public entry fun mint_to_sender(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        let nft = DevNetNFT {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(url)
        };
        event::emit(NFTMinted {
            object_id: object::id(&nft),
            creator: sender,
            name: nft.name,
        });
        transfer::public_transfer(nft, sender);
    }
    /// Transfer NFT to a new owner
    public entry fun transfer(
        nft: DevNetNFT, recipient: address, _: &mut TxContext
    ) {
        transfer::public_transfer(nft, recipient)
    }
    /// Update the NFT's description
    public entry fun update_description(
        nft: &mut DevNetNFT,
        new_description: vector<u8>,
        _: &mut TxContext
    ) {
        nft.description = string::utf8(new_description)
    }
    /// Permanently delete the NFT
    public entry fun burn(nft: DevNetNFT, _: &mut TxContext) {
        let DevNetNFT { id, name: _, description: _, url: _ } = nft;
        object::delete(id)
    }
}