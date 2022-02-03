// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {IERC165} from "@shibuidao/solid/src/utils/interfaces/IERC165.sol";

/// @dev Royalty registry interface.
/// @author Shibui
/// @author Modified from Manifold (https://github.com/manifoldxyz/royalty-registry-solidity/blob/main/contracts/IRoyaltyRegistry.sol)
interface IRoyaltyRegistry is IERC165 {
    /// @param owner The address of the user changing the royalty address.
    /// @param tokenAddress The token address that was overwritten.
    /// @param royaltyAddress The royalty override address.
	event RoyaltyOverride(address indexed owner, address indexed tokenAddress, address indexed royaltyAddress);

	/// @notice Override the location of where to look up royalty information for a given token contract.
	/// @dev Allows for backwards compatibility and implementation of royalty logic for contracts that did not previously support them.
	/// @param tokenAddress The token address you wish to override.
	/// @param royaltyAddress The royalty override address.
	function setRoyaltyLookupAddress(address tokenAddress, address royaltyAddress) external payable;

	/// @notice Returns royalty address location.  Returns the tokenAddress by default, or the override if it exists.
	/// @param tokenAddress The token address you are looking up the royalty for.
	function getRoyaltyLookupAddress(address tokenAddress) external view returns (address);

	/// @notice Whether or not the message sender can override the royalty address for the given token address.
	/// @param tokenAddress The token address you are looking up the royalty for.
	function overrideAllowed(address tokenAddress) external view returns (bool);
}
