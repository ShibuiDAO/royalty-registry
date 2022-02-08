// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {ERC165} from "@shibuidao/solid/src/utils/ERC165.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {IERC165} from "@shibuidao/solid/src/utils/interfaces/IERC165.sol";
import {IERC2981} from "@shibuidao/solid/src/utils/interfaces/IERC2981.sol";

contract ERC2981RoyaltyOverride is ERC165, Ownable, IERC2981 {
	event RoyaltyRecipientUpdated(address indexed asset, address indexed newRecipient, address indexed previousRecipient, address executor);
	event RoyaltyPerMilleUpdated(address indexed asset, uint256 indexed newValue, uint256 indexed previousValue, address executor);

	address public immutable asset;

	/// @dev The wallet address to which royalties get paid.
	address payable private royaltyRecipient;

	/// @dev Royalty in %. Example: 10 => 1%, 25 => 2,5%, 300 => 30%
	uint256 private royaltyPerMille;

	constructor(address _asset) {
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

	/// @notice Sets the new address to which all system fees get paid.
	/// @param _royaltyRecipient Address of the new royalty recipient.
	function setRoyaltyRecipien(address payable _royaltyRecipient) external onlyOwner {
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
