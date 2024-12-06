// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract UserItems is ERC1155, Ownable {
    string public constant name = "UserItems";

    /// ITEMS
    //      Core Items
    uint256 public constant CASH = 0; // ERC20 with 18 decimals
    uint256 public constant HEALTH = 1; // ERC20 with NO Decimals
    uint256 public constant ATTACK = 2; // ERC20 with NO Decimals

    //     Real Estate Items will be generated dynamically

    //     Healing Items
    uint256 public constant POTION = 3; // ERC20 with NO Decimals
    uint256 public constant SUPER_POTION = 4; // ERC20 with NO Decimals

    /// END ITEMS

    uint256 private constant STARTER_PACK_CASH_AMOUNT = 10000 * 10 ** 18;
    uint256 private constant STARTER_PACK_HEALTH_AMOUNT = 100;

    mapping(address => bool) hasClaimedStarterPack;

    constructor()
        ERC1155("https://localhost:8001/items/{id}.json")
        Ownable(msg.sender)
    {
        _mint(msg.sender, CASH, 10 ** 18, "");
    }

    function claimStarterPack() external {
        require(
            !hasClaimedStarterPack[msg.sender],
            "Starter pack already claimed"
        );

        hasClaimedStarterPack[msg.sender] = true;

        _mint(msg.sender, CASH, STARTER_PACK_CASH_AMOUNT, "");
        _mint(msg.sender, HEALTH, STARTER_PACK_HEALTH_AMOUNT, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public override {
        require(
            id != CASH && id != HEALTH && id != ATTACK,
            "Cash and Health cannot be transferred, only minted or burned"
        );

        super.safeTransferFrom(from, to, id, amount, data);
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public override {
        for (uint256 i = 0; i < ids.length; ) {
            require(
                ids[i] != CASH && ids[i] != HEALTH && ids[i] != ATTACK,
                "Cash and Health cannot be transferred, only minted or burned"
            );

            unchecked {
                i++;
            }
        }

        super.safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        _mint(account, id, amount, data);
    }

    function mintBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(account, ids, amounts, data);
    }

    function burn(
        address account,
        uint256 id,
        uint256 amount
    ) public onlyOwner {
        _burn(account, id, amount);
    }

    function burnBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory amounts
    ) public onlyOwner {
        _burnBatch(account, ids, amounts);
    }

    // Healing Functions
    function healWithPotion(address account, uint256 amount) public {
        require(
            balanceOf(account, POTION) >= amount,
            "Not enough potions to heal"
        );

        _burn(account, POTION, amount);
        _mint(account, HEALTH, 10 * amount, "");
    }

    function healWithSuperPotion(address account, uint256 amount) public {
        require(
            balanceOf(account, SUPER_POTION) >= amount,
            "Not enough super potions to heal"
        );

        _burn(account, SUPER_POTION, amount);
        _mint(account, HEALTH, 50 * amount, "");
    }
}
