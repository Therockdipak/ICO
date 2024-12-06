// SPDX-License-Identifier:MIT
pragma solidity 0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

 contract Token1 is ERC20, ERC20Burnable {
    constructor() ERC20("ClementineToken", "CLMN") {
        _mint(msg.sender,30000000000);
    }
 }