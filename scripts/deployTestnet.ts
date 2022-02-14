import { ethers, upgrades } from 'hardhat';
import type { RoyaltyEngineV1, RoyaltyRegistry } from '../typechain';

async function main() {
	const [deployer] = await ethers.getSigners();

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

	console.log(
		[
			` - "RoyaltyRegistry" deployed to ${royaltyRegistry.address}`,
			` - "RoyaltyEngineV1" deployed to ${royaltyEngineV1.address}`,
			`Deployer address is ${deployer.address}`
		].join('\n')
	);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});
