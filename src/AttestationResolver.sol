// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@ethereum-attestation-service/eas-contracts/resolver/SchemaResolver.sol";
import "@ethereum-attestation-service/eas-contracts/IEAS.sol";

/**
 * @title AttesterResolver
 * @notice A chora_club schema resolver that checks whether the attestation is from chora_club' address.
 * @dev This contract allows verifying whether an attestation is from a specific attester address.
 */
contract AttesterResolver is SchemaResolver, Ownable {
    address public targetAttester;

    /**
     * @dev Constructor to initialize the contract with the EAS instance, target attester address, and initial owner.
     * @param _eas The EAS (Ethereum Attestation Service) contract instance.
     * @param _targetAttester The target attester address to verify attestations.
     * @param _initialOwner The initial owner of the contract.
     */
    constructor(
        IEAS _eas,
        address _targetAttester,
        address _initialOwner
    ) SchemaResolver(_eas) Ownable(_initialOwner) {
        targetAttester = _targetAttester;
    }

    /**
     * @dev Updates the target attester address.
     * @param _newTargetAttester The new target attester address.
     * @notice Only the owner can update the target attester address.
     */
    function updateTargetAttester(address _newTargetAttester) public onlyOwner {
        targetAttester = _newTargetAttester;
    }

    /**
     * @dev Checks whether the attestation is from the target attester.
     * @param attestation The attestation data.
     * @return Whether the attestation is from the target attester.
     */
    function onAttest(
        Attestation calldata attestation,
        uint256 /*value*/
    ) internal view override returns (bool) {
        return attestation.attester == targetAttester;
    }

    /**
     * @dev Revoke function placeholder.
     * @return Always returns false as revocation is not allowed.
     */
    function onRevoke(
        Attestation calldata /*attestation*/,
        uint256 /*value*/
    ) internal pure override returns (bool) {
        return false;
    }
}
