import { defaultAbiCoder } from '@ethersproject/abi';
import { mkdirSync, writeFileSync } from 'fs';
import { ethers, upgrades } from 'hardhat';
import { join } from 'path';
import type { RoyaltyRegistry } from '../../typechain';

async function main() {
	const [deployer] = await ethers.getSigners();
	const shibuiMetaDirectory = join(__dirname, '..', '..', '.shibui');

    const RoyaltyRegistryContract = await ethers.getContractFactory('RoyaltyRegistry');
    const royaltyRegistry = (await upgrades.deployProxy(RoyaltyRegistryContract, [], {
        initializer: 'initialize',
        kind: 'transparent'
    })) as RoyaltyRegistry;
    await royaltyRegistry.deployed();

	console.log(
		[
			`Joint testnet contracts: ` /**/,
			` - "RoyaltyRegistry" deployed to ${royaltyRegistry.address}`,
			` - Deployer address is ${deployer.address}`
		].join('\n')
	);

	const encodedData = defaultAbiCoder.encode(['address'], [royaltyRegistry.address]);

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
