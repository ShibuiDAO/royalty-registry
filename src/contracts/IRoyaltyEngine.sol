// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {IERC165} from "@shibuidao/solid/src/utils/interfaces/IERC165.sol";

/// @dev Lookup engine interface
/// @author Modified from Manifold (https://github.com/manifoldxyz/royalty-registry-solidity/blob/main/contracts/IRoyaltyEngineV1.sol)
interface IRoyaltyEngine is IERC165 {
	/// @notice Get the royalty for a given token (address, id) and value amount.  Does not cache the bps/amounts.  Caches the spec for a given token address.
	/// @param tokenAddress The address of the token.
	/// @param tokenId The id of the token.
	/// @param value The value you wish to get the royalty of.
	/// @return recipients Address' of the royalty recipients.
	/// @return amounts Corresponding amount of a recipients royalty.
	function getRoyalty(
		address tokenAddress,
		uint256 tokenId,
		uint256 value
	) external payable returns (address payable[] memory recipients, uint256[] memory amounts);

	/// @notice View only version of getRoyalty.
	/// @param tokenAddress The address of the token.
	/// @param tokenId The id of the token.
	/// @param value The value you wish to get the royalty of.
	/// @return recipients Address' of the royalty recipients.
	/// @return amounts Corresponding amount of a recipients royalty.
	function getRoyaltyView(
		address tokenAddress,
		uint256 tokenId,
		uint256 value
	) external view returns (address payable[] memory recipients, uint256[] memory amounts);
}
