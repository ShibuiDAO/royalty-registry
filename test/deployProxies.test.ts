import chai from 'chai';
import { solidity } from 'ethereum-waffle';
import { ethers, upgrades } from 'hardhat';
import type { RoyaltyEngineV1, RoyaltyRegistry } from '../typechain';

chai.use(solidity);

describe('Deploy Proxies', () => {
	describe('RoyaltyRegisty', () => {
		it('Should deploy', async () => {
			const RoyaltyRegistryContract = await ethers.getContractFactory('RoyaltyRegistry');
			const royaltyRegistry = (await upgrades.deployProxy(RoyaltyRegistryContract, [], {
				initializer: '__RoyaltyRegistry_init',
				kind: 'transparent'
			})) as RoyaltyRegistry;
			await royaltyRegistry.deployed();
		});
	});

	describe('RoyaltyEngineV1', () => {
		it('Should deploy', async () => {
			const RoyaltyRegistryContract = await ethers.getContractFactory('RoyaltyRegistry');
			const royaltyRegistry = (await upgrades.deployProxy(RoyaltyRegistryContract, [], {
				initializer: '__RoyaltyRegistry_init',
				kind: 'transparent'
			})) as RoyaltyRegistry;
			await royaltyRegistry.deployed();

			const RoyaltyEngineV1Contract = await ethers.getContractFactory('RoyaltyEngineV1');
			const royaltyEngineV1 = (await upgrades.deployProxy(RoyaltyEngineV1Contract, [royaltyRegistry.address], {
				initializer: '__RoyaltyEngineV1_init',
				kind: 'transparent'
			})) as RoyaltyEngineV1;
			await royaltyEngineV1.deployed();
		});
	});
});
