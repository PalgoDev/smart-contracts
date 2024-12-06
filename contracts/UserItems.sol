// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract UserItems is ERC1155 {
    string public constant name = "UserItems";
    uint256 public constant CASH = 0; // ERC20 with 18 decimals

    uint256 private constant STARTER_PACK_CASH_AMOUNT = 10000 * 10 ** 18;

    mapping(address => bool) hasClaimedStarterPack;

    constructor() ERC1155("https://localhost:8001/items/{id}.json") {
        _mint(msg.sender, CASH, 10 ** 18, "");
    }

    function claimStarterPack() external {
        require(
            !hasClaimedStarterPack[msg.sender],
            "Starter pack already claimed"
        );

        hasClaimedStarterPack[msg.sender] = true;

        _mint(msg.sender, CASH, STARTER_PACK_CASH_AMOUNT, "");
    }
}
