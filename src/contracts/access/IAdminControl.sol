// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {IERC165} from "@shibuidao/solid/src/utils/interfaces/IERC165.sol";

/// @dev Interface for admin control.
/// @author Manifold (NPM @manifoldxyz/libraries-solidity (https://www.npmjs.com/package/@manifoldxyz/libraries-solidity))
interface IAdminControl is IERC165 {
	event AdminApproved(address indexed account, address indexed sender);
	event AdminRevoked(address indexed account, address indexed sender);

	/// @notice Gets address of all admins.
	function getAdmins() external view returns (address[] memory);

	/// @notice Add an admin.
	/// @dev Can only be called by contract owner.
	function approveAdmin(address admin) external;

	/// @notice Remove an admin.
	/// @dev Can only be called by contract owner.
	function revokeAdmin(address admin) external;

	/// @notice checks whether or not given address is an admin.
	/// Returns True if they are.
	function isAdmin(address admin) external view returns (bool);
}
