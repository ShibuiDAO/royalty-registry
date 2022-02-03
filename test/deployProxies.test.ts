import chai from 'chai';
import { solidity } from 'ethereum-waffle';
import { ethers, upgrades } from 'hardhat';
import type { RoyaltyRegistry } from '../typechain';

chai.use(solidity);

describe('Deploy Proxies', () => {
	describe('RoyaltyRegisty', () => {
		it('Should deploy', async () => {
			const RoyaltyRegistry = await ethers.getContractFactory('RoyaltyRegistry');
			const contract = (await upgrades.deployProxy(RoyaltyRegistry, [], {
				initializer: 'initialize',
				kind: 'transparent'
			})) as RoyaltyRegistry;
			await contract.deployed();
		});
	});
});
