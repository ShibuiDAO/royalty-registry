// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {ERC165} from "@shibuidao/solid/src/utils/ERC165.sol";
import {ERC165Checker} from "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {AddressUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

import {IRoyaltyEngine} from "./IRoyaltyEngine.sol";
import {IRoyaltyEngineV1} from "./IRoyaltyEngineV1.sol";
import {IRoyaltyRegistry} from "./IRoyaltyRegistry.sol";
import {IERC165} from "@shibuidao/solid/src/utils/interfaces/IERC165.sol";
import {IERC2981} from "@shibuidao/solid/src/utils/interfaces/IERC2981.sol";

/// @notice Engine to lookup royalty configurations.
/// @author Shibui
/// @author Modified from Manifold (https://github.com/manifoldxyz/royalty-registry-solidity/blob/main/contracts/RoyaltyEngineV1.sol)
contract RoyaltyEngineV1 is ERC165, Initializable, OwnableUpgradeable, IRoyaltyEngineV1 {
	using AddressUpgradeable for address;

	// Use int16 for specs to support future spec additions
	// When we add a spec, we also decrement the NONE value
	// Anything > NONE and <= NOT_CONFIGURED is considered not configured
	int16 private constant NONE = -1;
	int16 private constant NOT_CONFIGURED = 0;
	int16 private constant EIP2981 = 1;

	mapping(address => int16) private _specCache;

	address public royaltyRegistry;

	/// @custom:oz-upgrades-unsafe-allow constructor
	// solhint-disable-next-line no-empty-blocks
	constructor() initializer {}

	// solhint-disable-next-line func-name-mixedcase
	function __RoyaltyEngineV1_init(address _royaltyRegistry) public initializer {
		__Ownable_init();
		require(ERC165Checker.supportsInterface(_royaltyRegistry, type(IRoyaltyRegistry).interfaceId), "REGISTY_ADDRESS_NOT_COMPLIANT");
		royaltyRegistry = _royaltyRegistry;
	}

	/// @inheritdoc IERC165
	function supportsInterface(bytes4 interfaceId) public pure virtual override(ERC165, IERC165) returns (bool) {
		return interfaceId == type(IRoyaltyEngineV1).interfaceId || super.supportsInterface(interfaceId);
	}

	/// @inheritdoc IRoyaltyEngine
	function getRoyalty(
		address tokenAddress,
		uint256 tokenId,
		uint256 value
	) public payable override returns (address payable[] memory recipients, uint256[] memory amounts) {
		int16 spec;
		address royaltyAddress;
		bool addToCache;

		(recipients, amounts, spec, royaltyAddress, addToCache) = _getRoyaltyAndSpec(tokenAddress, tokenId, value);
		if (addToCache) _specCache[royaltyAddress] = spec;
		return (recipients, amounts);
	}

	/// @inheritdoc IRoyaltyEngine
	function getRoyaltyView(
		address tokenAddress,
		uint256 tokenId,
		uint256 value
	) public view override returns (address payable[] memory recipients, uint256[] memory amounts) {
		(recipients, amounts, , , ) = _getRoyaltyAndSpec(tokenAddress, tokenId, value);
		return (recipients, amounts);
	}

	/// @notice Get the royalty and royalty spec for a given token.
    /// @return recipients Array of address' for royalty payments.
    /// @return amounts Array of royalty amounts for a given address at the same index in "recipients".
    /// @return spec The spec that was found and used for this calculation.
    /// @return royaltyAddress The address retrieved from the RoyaltyRegistry.
    /// @return addToCache Whether or not to add the returned "spec" to the cache.
	function _getRoyaltyAndSpec(
		address tokenAddress,
		uint256 tokenId,
		uint256 value
	)
		private
		view
		returns (
			address payable[] memory recipients,
			uint256[] memory amounts,
			int16 spec,
			address royaltyAddress,
			bool addToCache
		)
	{
		royaltyAddress = IRoyaltyRegistry(royaltyRegistry).getRoyaltyLookupAddress(tokenAddress);
		spec = _specCache[royaltyAddress];

		if (spec <= NOT_CONFIGURED && spec > NONE) {
			// No spec configured yet, so we need to detect the spec
			addToCache = true;

			try IERC2981(royaltyAddress).royaltyInfo(tokenId, value) returns (address recipient, uint256 amount) {
				// Supports EIP2981.  Return amounts
				require(amount < value, "ROYALTY_AMOUNT_INVALID");
				recipients = new address payable[](1);
				amounts = new uint256[](1);
				recipients[0] = payable(recipient);
				amounts[0] = amount;
				return (recipients, amounts, EIP2981, royaltyAddress, addToCache);
				// solhint-disable-next-line no-empty-blocks
			} catch {}

			// No supported royalties configured
			return (recipients, amounts, NONE, royaltyAddress, addToCache);
		} else {
			// Spec exists, just execute the appropriate one
			addToCache = false;
			if (spec == NONE) {
				return (recipients, amounts, spec, royaltyAddress, addToCache);
			} else if (spec == EIP2981) {
				// EIP2981 spec handling
				(address recipient, uint256 amount) = IERC2981(royaltyAddress).royaltyInfo(tokenId, value);
				require(amount < value, "ROYALTY_AMOUNT_INVALID");
				recipients = new address payable[](1);
				amounts = new uint256[](1);
				recipients[0] = payable(recipient);
				amounts[0] = amount;
				return (recipients, amounts, spec, royaltyAddress, addToCache);
			}
		}
	}

	/// @notice Compute royalty amounts.
	function _computeAmounts(uint256 value, uint256[] memory bps) private pure returns (uint256[] memory amounts) {
		amounts = new uint256[](bps.length);
		uint256 totalAmount;
		for (uint256 i = 0; i < bps.length; i++) {
			amounts[i] = (value * bps[i]) / 10000;
			totalAmount += amounts[i];
		}
		require(totalAmount < value, "ROYALTY_AMOUNT_INVALID");
		return amounts;
	}

	/// @notice Withdraws any Ether in-case it's ever accidentaly sent to the contract.
	function withdraw() public onlyOwner {
		uint256 balance = address(this).balance;
		payable(msg.sender).transfer(balance);
	}
}
