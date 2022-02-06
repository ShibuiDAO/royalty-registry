// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {BaseTest} from "@shibuidao/solid/src/tests/base/BaseTest.sol";

import {MockRoyaltyRegistry} from "./utils/mocks/MockRoyaltyRegistry.sol";
import {MockRoyaltyEngineV1} from "./utils/mocks/MockRoyaltyEngineV1.sol";
import {MockERC721} from "./utils/mocks/MockERC721.sol";

contract RoyaltyEngineV1Test is BaseTest {
	MockRoyaltyRegistry internal royaltyRegistry;
	MockRoyaltyEngineV1 internal royaltyEngineV1;
	MockERC721 internal token;

	function setUp() public {
		royaltyRegistry = new MockRoyaltyRegistry();
		royaltyEngineV1 = new MockRoyaltyEngineV1();
		vm.startPrank(0x3711D654fC31fc70039B485a77c082e8e89D9F05);
		royaltyRegistry.mockInit();
		royaltyEngineV1.mockInit(address(royaltyRegistry));
		vm.stopPrank();

		token = new MockERC721("Mock Token", "MTKN");
	}

	function testDefaultViewReturn() public {
		(address payable[] memory recipients, uint256[] memory amounts) = royaltyEngineV1.getRoyaltyView(address(token), 1, 1);
		assertEq(recipients.length, 0);
		assertEq(amounts.length, 0);
	}
}
