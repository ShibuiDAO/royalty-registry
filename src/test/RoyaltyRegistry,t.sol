// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {BaseTest} from "@shibuidao/solid/src/tests/base/BaseTest.sol";

import {IRoyaltyRegistry} from "../contracts/IRoyaltyRegistry.sol";

contract RoyaltyRegistryTest is BaseTest {
	IRoyaltyRegistry internal royaltyRegistry;

	function setUp() public {
		string[] memory deploymentAddressCommand = new string[](2);
		deploymentAddressCommand[0] = "cat";
		deploymentAddressCommand[1] = ".shibui/deployments";

		bytes memory deploymentAddresses = vm.ffi(deploymentAddressCommand);
		(address _royaltyRegistry) = abi.decode(deploymentAddresses, (address));

		royaltyRegistry = IRoyaltyRegistry(_royaltyRegistry);
	}
}
