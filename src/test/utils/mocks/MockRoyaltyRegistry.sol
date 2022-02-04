// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {RoyaltyRegistry} from "../../../contracts/RoyaltyRegistry.sol";

contract MockRoyaltyRegistry is RoyaltyRegistry {
	function mockInit() public {
		_transferOwnership(_msgSender());
	}
}
