// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @author: manifold.xyz

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "./MultiReceiverRoyaltyOverrideCore.sol";
import "./IRoyaltySplitter.sol";
import "../IRoyaltyRegistry.sol";

/**
 * Simple EIP2981 reference override implementation
 */
contract EIP2981MultiReceiverRoyaltyOverrideCloneable is EIP2981MultiReceiverRoyaltyMultiReceiverOverrideCore, OwnableUpgradeable {

    function initialize(address payable royaltySplitterCloneable, address royaltyRegistry, address tokenAddress, uint16 defaultBps, Recipient[] memory defaultRecipients) public initializer {
        __Ownable_init();
        _royaltySplitterCloneable = royaltySplitterCloneable;
        // Auto registration of token address with the royalty registry
        IRoyaltyRegistry(royaltyRegistry).setRoyaltyLookupAddress(tokenAddress, address(this));
        // Initialize with default royalties
        _setDefaultRoyalty(defaultBps, defaultRecipients);
    }

    /**
     * @dev See {IEIP2981MultiReceiverRoyaltyOverride-setTokenRoyalties}.
     */
    function setTokenRoyalties(TokenRoyaltyConfig[] calldata royaltyConfigs) external override onlyOwner {
        _setTokenRoyalties(royaltyConfigs);
    }

    /**
     * @dev See {IEIP2981MultiReceiverRoyaltyOverride-setDefaultRoyalty}.
     */
    function setDefaultRoyalty(uint16 bps, Recipient[] calldata recipients) external override onlyOwner {
        _setDefaultRoyalty(bps, recipients);
    }
}
