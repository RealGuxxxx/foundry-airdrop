# MerkleAirdrop 合约

## 概述
`MerkleAirdrop` 是一个基于以太坊的空投合约，使用 Merkle 树验证用户的空投资格。合约允许用户在提供有效的 Merkle 证明和签名的情况下，领取指定数量的代币。

## 合约功能

### 1. 事件
- `Claim`: 当用户成功领取空投时触发，记录领取者的地址和领取的数量。

### 2. 错误
- `MerkleAirdrop__InvalidProof`: 当提供的 Merkle 证明无效时抛出。
- `MerkleAirdrop__AlreadyClaimed`: 当用户已经领取过空投时抛出。
- `MerkleAirdrop__InvalidSignature`: 当签名无效时抛出。

### 3. 状态变量
- `i_merkleRoot`: 存储 Merkle 树的根哈希。
- `i_airdropToken`: 存储空投代币的合约地址。
- `s_hasClaimed`: 记录每个地址是否已经领取过空投。

### 4. 构造函数
合约的构造函数接受 Merkle 根和空投代币的地址，并初始化 EIP712 签名。

```solidity
constructor(bytes32 merkleRoot, IERC20 airdropToken) EIP712("Airdrop", "1") {
    i_merkleRoot = merkleRoot;
    i_airdropToken = airdropToken;
}
```

### 5. 领取空投
`claim` 函数允许用户领取空投。该函数接受账户地址、领取数量、Merkle 证明和签名参数。

```solidity
function claim(address account, uint256 amount, bytes32[] calldata merkleProof, uint8 v, bytes32 r, bytes32 s) external {
    // 检查用户是否已领取
    // 验证签名
    // 验证 Merkle 证明
    // 转移代币
    // 记录已领取状态
    // 触发 Claim 事件
}
```

- **参数**:
  - `account`: 领取空投的账户地址。
  - `amount`: 领取的代币数量。
  - `merkleProof`: Merkle 证明数组。
  - `v`, `r`, `s`: 签名参数。

### 6. 获取消息
`getMessage` 函数生成用于签名的消息哈希。

```solidity
function getMessage(address account, uint256 amount) public view returns (bytes32) {
    // 返回消息哈希
}
```

### 7. 验证签名
`_isValidSignature` 函数用于验证签名的有效性。

```solidity
function _isValidSignature(address signer, bytes32 digest, uint8 v, bytes32 r, bytes32 s) internal pure returns (bool) {
    // 验证签名
}
```

## 使用说明
1. 部署合约时，提供 Merkle 根和空投代币的合约地址。
2. 用户调用 `claim` 函数，提供必要的参数以领取空投。

## 安全性
- 该合约使用 OpenZeppelin 的库，确保遵循最佳安全实践。
- 通过 Merkle 树和 EIP712 签名机制，确保空投的安全性和有效性。



# 脚本合约功能介绍

## 1. `MakeMerkle.s.sol`

### 概述
`MakeMerkle` 合约是一个用于生成 Merkle 证明的脚本。它从输入文件中读取数据，生成 Merkle 树，并将结果输出到 JSON 文件中。该合约使用了 Murky 库来处理 Merkle 树的相关操作。

### 功能
- **读取输入文件**: 从指定的 JSON 文件中读取数据，包括地址和数量。
- **生成 Merkle 证明**: 对每个叶节点生成 Merkle 证明，并计算 Merkle 根。
- **输出结果**: 将生成的 Merkle 证明、根哈希和叶节点信息写入到输出 JSON 文件中。

### 使用步骤
1. 运行 `forge script script/GenerateInput.s.sol` 生成输入文件。
2. 运行 `forge script script/Merkle.s.sol` 生成 Merkle 证明。
3. 输出文件将生成在 `/script/target/output.json`。

---

## 2. `MerkleAirdrop.sol`

### 概述
`MerkleAirdrop` 合约是一个基于 Merkle 树的空投合约，允许用户在提供有效的 Merkle 证明和签名的情况下领取代币。该合约确保只有符合条件的用户才能领取空投。

### 功能
- **领取空投**: 用户可以通过 `claim` 函数领取代币，前提是提供有效的 Merkle 证明和签名。
- **验证机制**: 合约使用 Merkle 树和 EIP712 签名机制来验证用户的资格，确保安全性。
- **事件记录**: 成功领取空投时触发 `Claim` 事件，记录领取者的地址和领取的数量。

### 错误处理
- 合约定义了多种错误处理机制，以确保在无效证明、重复领取或无效签名的情况下能够正确反馈。

---

这两个文件共同工作，`MakeMerkle` 生成 Merkle 证明，而 `MerkleAirdrop` 则使用这些证明来安全地分发代币给符合条件的用户。