## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

deployment command

```shell
$ forge create --rpc-url $RPC_URL --private-key $PVT_KEY AttesterResolver --constructor-args-path ./op_args.json --etherscan-api-key $ETHERSCAN_APIKEY --verify
```

## Why optimizer kept to 200 runs?

- **Optimizer Limited to 200 Runs:**

  - Gas Usage: 636,231 gas
  - Transaction Fee: 0.001990916022559779 ETH ($3.68) @ 3.000000256 Gwei
  - Bytecode Length (Char): 4,919 characters
  - [Deploy Tx (200 runs)](https://sepolia-optimism.etherscan.io/address/0x31dfd21a6c9a60183ef559b239e00e0f3f76259c)

- **Optimizer Increased to 10,000,000 Runs:**
  - Gas Usage: 764,202 gas
  - Transaction Fee: 0.00236498685805258 ETH ($4.38) @ 3.000000252 Gwei
  - Bytecode Length (Char): 5,144 characters
  - [Deploy Tx (10,000,000 runs)](https://sepolia-optimism.etherscan.io/address/0x85006cf734a48806170ce45bcfd4fe0fbb121656)

Explanation: When the optimizer is set to 10,000,000 runs, gas fees increase due to longer bytecode length. Therefore, keeping it limited to 200 runs helps maintain lower gas fees and a shorter bytecode length.

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@ethereum-attestation-service/eas-contracts/contracts/resolver/SchemaResolver.sol";
import "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";

/**
 * @title AttesterResolver
 * @notice A chora_club schema resolver that checks whether the attestation is from chora_club' address.
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract AttesterResolver is SchemaResolver, Ownable {
    address public targetAttester;

    constructor(
        IEAS _eas,
        address _targetAttester,
        address _initialOwner
    ) SchemaResolver(_eas) Ownable(_initialOwner) {
        targetAttester = _targetAttester;
    }

    function updateTargetAttester(address _newTargetAttester) public onlyOwner {
        targetAttester = _newTargetAttester;
    }

    function onAttest(
        Attestation calldata attestation,
        uint256 /*value*/
    ) internal view override returns (bool) {
        return attestation.attester == targetAttester;
    }

    function onRevoke(
        Attestation calldata, /*attestation*/
        uint256 /*value*/
    ) internal pure override returns (bool) {
        return false;
    }
}

```
