import chai from 'chai';
import { solidity } from 'ethereum-waffle';
import { ethers, upgrades } from 'hardhat';
import type { RoyaltyRegistry } from '../typechain';

chai.use(solidity);

describe('Deploy Proxies', () => {
	describe('RoyaltyRegisty', () => {
		it('Should deploy', async () => {
			const RoyaltyRegistryContract = await ethers.getContractFactory('RoyaltyRegistry');
			const royaltyRegistry = (await upgrades.deployProxy(RoyaltyRegistryContract, [], {
				initializer: 'initialize',
				kind: 'transparent'
			})) as RoyaltyRegistry;
			await royaltyRegistry.deployed();
		});
	});
});
