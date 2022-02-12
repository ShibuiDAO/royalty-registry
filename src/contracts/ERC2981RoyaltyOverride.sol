// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {ERC165} from "@shibuidao/solid/src/utils/ERC165.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {ERC165Checker} from "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";

import {IERC165} from "@shibuidao/solid/src/utils/interfaces/IERC165.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {IERC2981} from "@shibuidao/solid/src/utils/interfaces/IERC2981.sol";

/// @author ShibuiDAO (https://github.com/ShibuiDAO/royalty-registry/blob/main/src/contracts/ERC2981RoyaltyOverride.sol)
contract ERC2981RoyaltyOverride is ERC165, Ownable, IERC2981 {
	/// @param asset The address of the asset contract for which these royalties apply.
	/// @param newRecipient The newly provided `royaltyRecipient`.
	/// @param previousRecipient The previously stored `royaltyRecipient`.
	/// @param executor The address that triggered these changes.
	event RoyaltyRecipientUpdated(address indexed asset, address indexed newRecipient, address indexed previousRecipient, address executor);

	/// @param asset The address of the asset contract for which these royalties apply.
	/// @param newValue The newly provided `royaltyPerMille`.
	/// @param previousValue The previously stored `royaltyPerMille`.
	/// @param executor The address that triggered these changes.
	event RoyaltyPerMilleUpdated(address indexed asset, uint256 indexed newValue, uint256 indexed previousValue, address executor);

	/// @notice The address of the asset contract for which these royalties apply.
	/// @dev This value is checked for compliance against ERC721 or ERC1155.
	address public immutable asset;

	/// @notice The wallet address to which royalties get paid.
	address payable public royaltyRecipient;

	/// @notice Royalty in %. Example: 10 => 1%, 25 => 2,5%, 300 => 30%.
	uint256 public royaltyPerMille;

	/// @param _asset The address of the asset contract for which these royalties apply.
	constructor(address _asset) {
		require(
			ERC165Checker.supportsInterface(_asset, type(IERC721).interfaceId) || ERC165Checker.supportsInterface(_asset, type(IERC1155).interfaceId),
			"ASSET_ADDRESS_NOT_COMPLIANT"
		);
		asset = _asset;
		royaltyRecipient = payable(_msgSender());
	}

	/// @inheritdoc IERC165
	function supportsInterface(bytes4 interfaceId) public pure virtual override(ERC165, IERC165) returns (bool) {
		return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
	}

	/// @inheritdoc IERC2981
	function royaltyInfo(uint256, uint256 _salePrice) public view override returns (address receiver, uint256 royaltyAmount) {
		if (royaltyPerMille == 0) return (royaltyRecipient, 0);
		return (royaltyRecipient, (royaltyPerMille * _salePrice) / 1000);
	}

	/// @notice Sets the new address to which all royalties get paid.
	/// @param _royaltyRecipient Address of the new royalty recipient.
	function setRoyaltyRecipient(address payable _royaltyRecipient) external onlyOwner {
		emit RoyaltyRecipientUpdated(asset, _royaltyRecipient, royaltyRecipient, _msgSender());
		royaltyRecipient = _royaltyRecipient;
	}

	/// @notice Sets the new royalty %. Example: 10 => 1%, 25 => 2,5%, 300 => 30%
	/// @param _royaltyPerMille New royalty amount.
	function setRoyaltyPerMille(uint256 _royaltyPerMille) external onlyOwner {
		emit RoyaltyPerMilleUpdated(asset, _royaltyPerMille, royaltyPerMille, _msgSender());
		royaltyPerMille = _royaltyPerMille;
	}
}
