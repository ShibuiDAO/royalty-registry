// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {BaseTest} from "@shibuidao/solid/src/tests/base/BaseTest.sol";

import {IRoyaltyRegistry} from "../contracts/IRoyaltyRegistry.sol";

import {MockERC721} from "./utils/mocks/MockERC721.sol";

contract RoyaltyRegistryTest is BaseTest {
	IRoyaltyRegistry internal royaltyRegistry;
	MockERC721 internal token;

	function setUp() public {
		string[] memory deploymentAddressCommand = new string[](2);
		deploymentAddressCommand[0] = "cat";
		deploymentAddressCommand[1] = ".shibui/deployments";

		bytes memory deploymentAddresses = vm.ffi(deploymentAddressCommand);
		address _royaltyRegistry = abi.decode(deploymentAddresses, (address));

		royaltyRegistry = IRoyaltyRegistry(_royaltyRegistry);
		token = new MockERC721("Mock Token", "MTKN");
	}

	function testDefaultReturn() public {
		assertEq(royaltyRegistry.getRoyaltyLookupAddress(address(token)), address(token));
	}

    function testAllowRejects() public {
        vm.startPrank(0x7D4cCAb3828E8A215845b89Cdb5D873bbe1EEA7E);
        vm.expectRevert("Permission denied");
		royaltyRegistry.setRoyaltyLookupAddress(address(token), address(token));
	}
}
