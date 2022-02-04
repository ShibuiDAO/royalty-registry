import { ethers, upgrades } from 'hardhat';
import type { RoyaltyRegistry } from '../typechain';

async function main() {
	const [deployer] = await ethers.getSigners();

	const RoyaltyRegistryContract = await ethers.getContractFactory('RoyaltyRegistry');
	const royaltyRegistry = (await upgrades.deployProxy(RoyaltyRegistryContract, [], {
		initializer: '__RoyaltyRegistry_init',
		kind: 'transparent'
	})) as RoyaltyRegistry;
	await royaltyRegistry.deployed();

	console.log(
		[
			`Deployed:` /**/, //
			` - "RoyaltyRegistry" deployed to ${royaltyRegistry.address}`,
			` - Deployer address is ${deployer.address}`
		].join('\n')
	);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});
