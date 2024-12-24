// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract YouTiaoToken is ERC20, Ownable {

    // constructor(address initialAddress) ERC20("YouTiaoToken", "YTT") Ownable(initialAddress) {
        
    // }
    constructor() ERC20("YouTiaoToken", "YTT") Ownable(msg.sender) {
        
    }

    /**
     * 
     * @param account 指定铸造的账户
     * @param amount 铸造的数量
     */
    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    
}