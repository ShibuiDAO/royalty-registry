// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// @author Solid (https://github.com/ShibuiDAO/solid/blob/main/src/utils/IERC165.sol)
/// @author Modified from Ethereum Improvement Proposals #165 (https://eips.ethereum.org/EIPS/eip-165)
interface IERC165 {
	function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
