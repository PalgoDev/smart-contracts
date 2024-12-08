// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract UserItems is ERC1155, Ownable {
    string public constant name = "UserItems";

    /// ITEMS
    //      Core Items
    uint256 public constant CASH = 0; // ERC20 with 18 decimals
    uint256 public constant HEALTH = 1;
    uint256 public constant ATTACK = 2;
    uint256 public constant DEFENSE = 3;

    //     Real Estate Items will be generated dynamically

    //     Healing Items
    uint256 public constant POTION = 4;
    uint256 public constant SUPER_POTION = 5;

    /// END ITEMS

    uint256 public constant HEALTH_BY_POTION = 10;
    uint256 public constant HEALTH_BY_SUPER_POTION = 50;

    uint256 private constant STARTER_PACK_CASH_AMOUNT = 1000 * 10 ** 18;
    uint256 private constant STARTER_PACK_HEALTH_AMOUNT = 100;
    uint256 private constant STARTER_PACK_ATTACK_AMOUNT = 100;
    uint256 private constant STARTER_PACK_DEFENSE_AMOUNT = 100;

    mapping(address => bool) public hasClaimedStarterPack;

    address public tokenAddress;

    constructor()
        ERC1155("https://backend-3jc3.onrender.com/items/{id}.json")
        Ownable(msg.sender)
    {
        _mint(msg.sender, CASH, 10 ** 18, "");
    }

    function setTokenAddress(address _tokenAddress) public onlyOwner {
        tokenAddress = _tokenAddress;
    }

    function claimStarterPack() external {
        require(
            !hasClaimedStarterPack[msg.sender],
            "Starter pack already claimed"
        );

        hasClaimedStarterPack[msg.sender] = true;

        _mint(msg.sender, CASH, STARTER_PACK_CASH_AMOUNT, "");
        _mint(msg.sender, HEALTH, STARTER_PACK_HEALTH_AMOUNT, "");
        _mint(msg.sender, ATTACK, STARTER_PACK_ATTACK_AMOUNT, "");
        _mint(msg.sender, DEFENSE, STARTER_PACK_DEFENSE_AMOUNT, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public override {
        require(
            id != CASH && id != HEALTH && id != ATTACK && id != DEFENSE,
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
                ids[i] != CASH &&
                    ids[i] != HEALTH &&
                    ids[i] != ATTACK &&
                    ids[i] != DEFENSE,
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
    function healWithPotion(uint256 quantity) public {
        address account = msg.sender;
        require(
            balanceOf(account, POTION) >= quantity,
            "Not enough potions to heal"
        );

        _burn(account, POTION, quantity);
        _mint(account, HEALTH, quantity * HEALTH_BY_POTION, "");
    }

    function healWithSuperPotion(uint256 quantity) public {
        address account = msg.sender;
        require(
            balanceOf(account, SUPER_POTION) >= quantity,
            "Not enough super potions to heal"
        );

        _burn(account, SUPER_POTION, quantity);
        _mint(account, HEALTH, quantity * HEALTH_BY_SUPER_POTION, "");
    }

    function buyUnit(uint256 tokenId) public {
        if (tokenId == POTION) {
            require(
                IERC20(tokenAddress).transferFrom(
                    msg.sender,
                    address(this),
                    1 * 10 ** 18
                ),
                "Transfer failed"
            );
            _mint(msg.sender, POTION, 1, "");
        } else if (tokenId == SUPER_POTION) {
            require(
                IERC20(tokenAddress).transferFrom(
                    msg.sender,
                    address(this),
                    5 * 10 ** 18
                ),
                "Transfer failed"
            );
            _mint(msg.sender, SUPER_POTION, 1, "");
        } else if (tokenId == CASH) {
            require(
                IERC20(tokenAddress).transferFrom(
                    msg.sender,
                    address(this),
                    10 * 10 ** 18
                ),
                "Transfer failed"
            );
            _mint(msg.sender, CASH, 1000, "");
        } else {
            revert("Invalid token id");
        }
    }

    function withdrawTokenTo(address to, uint256 amount) public onlyOwner {
        require(IERC20(tokenAddress).transfer(to, amount), "Transfer failed");
    }
}
