// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract UserItems is ERC1155 {

    uint256 public constant CASH = 0; // ERC20 with 18 decimals

    constructor() ERC1155("https://localhost:8001/items/{id}.json") {
        _mint(msg.sender, CASH, 10 ** 18, "");
    }
}
