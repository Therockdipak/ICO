// SPDX-License-Identifier:MIT
pragma solidity 0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

 contract Token2 is ERC20 {
    constructor() ERC20("USDollar", "USDT") {
        _mint(msg.sender,3000000000);
    }
 }