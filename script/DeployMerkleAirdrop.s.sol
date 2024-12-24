// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {YouTiaoToken} from "src/YouTiaoToken.sol";
import {Script} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployMerkleAirdrop is Script {
    YouTiaoToken youTiaoToken;
    MerkleAirdrop airdrop;
    bytes32 constant ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 constant AMOUNT_TO_TRANSFER = 25000000000000000000 * 4;
    
    function run() external returns (MerkleAirdrop, YouTiaoToken) {
        vm.startBroadcast();
        youTiaoToken = new YouTiaoToken();
        airdrop = new MerkleAirdrop(ROOT, IERC20(youTiaoToken));
        youTiaoToken.mint(youTiaoToken.owner(), AMOUNT_TO_TRANSFER);
        IERC20(youTiaoToken).transfer(address(airdrop), AMOUNT_TO_TRANSFER);
        vm.stopBroadcast();
        return (airdrop, youTiaoToken);
    }
}
