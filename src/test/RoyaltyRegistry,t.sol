// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {BaseTest} from "@shibuidao/solid/src/tests/base/BaseTest.sol";

import {MockRoyaltyRegistry} from "./utils/mocks/MockRoyaltyRegistry.sol";
import {MockERC721} from "./utils/mocks/MockERC721.sol";

contract RoyaltyRegistryTest is BaseTest {
	MockRoyaltyRegistry internal royaltyRegistry;
	MockERC721 internal token;

	function setUp() public {
		royaltyRegistry = new MockRoyaltyRegistry();
        vm.startPrank(0x3711D654fC31fc70039B485a77c082e8e89D9F05);
        royaltyRegistry.mockInit();
        vm.stopPrank();

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
