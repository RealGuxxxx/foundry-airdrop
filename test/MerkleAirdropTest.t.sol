// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {YouTiaoToken} from "src/YouTiaoToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {ZkSyncChainChecker} from "foundry-devops/src/ZkSyncChainChecker.sol";
import {DeployMerkleAirdrop} from "script/DeployMerkleAirdrop.s.sol";

contract MerkleAirdropTest is Test, ZkSyncChainChecker {
    bytes32 ROOT =
        0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    YouTiaoToken token;
    MerkleAirdrop airdrop;

    address user;
    address user1;
    uint256 userPrivateKey;
    uint256 user1PrivateKey;
    address gasPayer;
    uint256 constant amountToSend = 25000000000000000000 * 4;
    uint256 constant airdropTokenAmount = 25000000000000000000;

    bytes32 proofOne =
        0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 proofTwo =
        0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] proof = [proofOne, proofTwo];

    function setUp() public {
        if (isZkSyncChain()) {
            DeployMerkleAirdrop deployer = new DeployMerkleAirdrop();
            (airdrop, token) = deployer.run();
        } else {
            token = new YouTiaoToken();
            airdrop = new MerkleAirdrop(ROOT, token);
            token.mint(msg.sender, amountToSend);
            vm.prank(msg.sender);
            token.transfer(address(airdrop), amountToSend);
        }
        (user, userPrivateKey) = makeAddrAndKey("user");
        (user1, user1PrivateKey) = makeAddrAndKey("user1");
        gasPayer = makeAddr("gasPayer");
    }

    function testIfECDSAWorks() external {
        console.log("before claim, user's balance: ", token.balanceOf(user));
        vm.startPrank(user);
        (uint8 v, bytes32 r, bytes32 s) = signMessage(userPrivateKey, user);
        vm.stopPrank();
        vm.prank(gasPayer);
        airdrop.claim(user, airdropTokenAmount, proof, v, r, s);
        console.log("after claim, user's balance: ", token.balanceOf(user));
    }

    function signMessage(
        uint256 privateKey,
        address account
    ) public view returns (uint8 v, bytes32 r, bytes32 s) {
        bytes32 hashedMessage = airdrop.getMessage(account, airdropTokenAmount);
        (v, r, s) = vm.sign(privateKey, hashedMessage);
    }
}
