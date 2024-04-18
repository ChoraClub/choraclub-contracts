// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/";

// import "@ethereum-attestation-service/eas-contracts/resolver/SchemaResolver.sol";
// import "@ethereum-attestation-service/eas-contracts/IEAS.sol";

/// @title AttesterResolver
/// @notice A chora_club schema resolver that checks whether the attestation is from chora_club' address.
contract AttesterResolver is SchemaResolver, Ownable {
    address public targetAttester;

    constructor(IEAS eas, address _targetAttester) SchemaResolver(eas) {
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
        Attestation calldata /*attestation*/,
        uint256 /*value*/
    ) internal pure override returns (bool) {
        return true;
    }
}
