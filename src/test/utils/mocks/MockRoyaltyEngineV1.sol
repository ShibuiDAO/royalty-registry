// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {RoyaltyEngineV1} from "../../../contracts/RoyaltyEngineV1.sol";

import {ERC165Checker} from "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";

import {IRoyaltyRegistry} from "../../../contracts/IRoyaltyRegistry.sol";

contract MockRoyaltyEngineV1 is RoyaltyEngineV1 {
	function mockInit(address _royaltyRegistry) public {
		_transferOwnership(_msgSender());
		require(ERC165Checker.supportsInterface(_royaltyRegistry, type(IRoyaltyRegistry).interfaceId), "REGISTY_ADDRESS_NOT_COMPLIANT");
		royaltyRegistry = _royaltyRegistry;
	}
}
