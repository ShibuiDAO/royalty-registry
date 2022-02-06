import { defaultAbiCoder } from '@ethersproject/abi';
import { mkdirSync, writeFileSync } from 'fs';
import { ethers, upgrades } from 'hardhat';
import { join } from 'path';
import type { RoyaltyEngineV1, RoyaltyRegistry } from '../../typechain';

async function main() {
	const [deployer] = await ethers.getSigners();
	const shibuiMetaDirectory = join(__dirname, '..', '..', '.shibui');

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
			`Joint testnet contracts: ` /**/, //
			` - "RoyaltyRegistry" deployed to ${royaltyRegistry.address}; Owner is ${await royaltyRegistry.owner()}`,
			` - "RoyaltyEngineV1" deployed to ${royaltyEngineV1.address}; Owner is ${await royaltyEngineV1.owner()}`,
			` - Deployer address is ${deployer.address}`
		].join('\n')
	);

	const encodedData = defaultAbiCoder.encode(['address', 'address'], [royaltyRegistry.address, royaltyEngineV1.address]);

	mkdirSync(shibuiMetaDirectory, { recursive: true });
	writeFileSync(join(shibuiMetaDirectory, 'deployments'), encodedData, {
		flag: 'w'
	});
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});
