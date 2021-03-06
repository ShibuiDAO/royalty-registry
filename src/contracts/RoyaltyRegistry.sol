// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {ERC165} from "@shibuidao/solid/src/utils/ERC165.sol";
import {ERC165Checker} from "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {AddressUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

import {IRoyaltyRegistry} from "./IRoyaltyRegistry.sol";
import {IERC165} from "@shibuidao/solid/src/utils/interfaces/IERC165.sol";
import {IAdminControl} from "./access/IAdminControl.sol";
import {IAccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/IAccessControlUpgradeable.sol";

/// @notice Registry to lookup royalty configurations.
/// @author Shibui
/// @author Modified from Manifold (https://github.com/manifoldxyz/royalty-registry-solidity/blob/main/contracts/RoyaltyRegistry.sol)
contract RoyaltyRegistry is ERC165, Initializable, OwnableUpgradeable, IRoyaltyRegistry {
	using AddressUpgradeable for address;

	/// @dev Override addresses
	mapping(address => address) private _overrides;

	/// @custom:oz-upgrades-unsafe-allow constructor
	// solhint-disable-next-line no-empty-blocks
	constructor() initializer {}

	// solhint-disable-next-line func-name-mixedcase
	function __RoyaltyRegistry_init() public initializer {
		__Ownable_init();
	}

	/// @inheritdoc IERC165
	function supportsInterface(bytes4 interfaceId) public pure virtual override(ERC165, IERC165) returns (bool) {
		return interfaceId == type(IRoyaltyRegistry).interfaceId || super.supportsInterface(interfaceId);
	}

	/// @inheritdoc IRoyaltyRegistry
	function getRoyaltyLookupAddress(address tokenAddress) external view override returns (address) {
		address override_ = _overrides[tokenAddress];
		if (override_ != address(0)) return override_;
		return tokenAddress;
	}

	/// @inheritdoc IRoyaltyRegistry
	function setRoyaltyLookupAddress(address tokenAddress, address royaltyLookupAddress) public payable override {
		require(tokenAddress.isContract() && (royaltyLookupAddress.isContract() || royaltyLookupAddress == address(0)), "Invalid input");
		require(overrideAllowed(tokenAddress), "Permission denied");
		_overrides[tokenAddress] = royaltyLookupAddress;
		emit RoyaltyOverride(_msgSender(), tokenAddress, royaltyLookupAddress);
	}

	/// @inheritdoc IRoyaltyRegistry
	function overrideAllowed(address tokenAddress) public view override returns (bool) {
		if (owner() == _msgSender()) return true;

		if (ERC165Checker.supportsInterface(tokenAddress, type(IAdminControl).interfaceId) && IAdminControl(tokenAddress).isAdmin(_msgSender())) {
			return true;
		}

		try OwnableUpgradeable(tokenAddress).owner() returns (address owner) {
			if (owner == _msgSender()) return true;
			// solhint-disable-next-line no-empty-blocks
		} catch {}

		try IAccessControlUpgradeable(tokenAddress).hasRole(0x00, _msgSender()) returns (bool hasRole) {
			if (hasRole) return true;
			// solhint-disable-next-line no-empty-blocks
		} catch {}

		return false;
	}

	/// @notice Withdraws any Ether in-case it's ever accidentaly sent to the contract.
	function withdraw() public onlyOwner {
		uint256 balance = address(this).balance;
		payable(msg.sender).transfer(balance);
	}
}
