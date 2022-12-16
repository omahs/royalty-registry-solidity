// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @author: manifold.xyz

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./MultiReceiverRoyaltyOverrideCloneable.sol";

/**
 * Clone Factory for EIP2981 reference override implementation
 */
contract EIP2981MultiReceiverRoyaltyOverrideFactory {

  address public originAddress;
  address payable public royaltySplitterOriginAddress;

  event EIP2981RoyaltyOverrideCreated(address newEIP2981RoyaltyOverride);

  constructor(address origin, address payable royaltySplitterOrigin) {
      originAddress = origin;
      royaltySplitterOriginAddress = royaltySplitterOrigin;
  }

  function createOverride(address royaltyRegistry, address tokenAddress, uint16 defaultBps, Recipient[] memory defaultRecipients) public returns (address) {
      address clone = Clones.clone(originAddress);
      EIP2981MultiReceiverRoyaltyOverrideCloneable(clone).initialize(royaltySplitterOriginAddress, royaltyRegistry, tokenAddress, defaultBps, defaultRecipients);
      EIP2981MultiReceiverRoyaltyOverrideCloneable(clone).transferOwnership(msg.sender);
      emit EIP2981RoyaltyOverrideCreated(clone);
      return clone;
  }
}