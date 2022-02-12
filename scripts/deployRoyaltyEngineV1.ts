import { ethers, upgrades } from 'hardhat';
import type { RoyaltyEngineV1 } from '../typechain';

const ROYALTY_REGISTRY_ADDRESS = process.env.ROYALTY_REGISTRY_ADDRESS || '0xF65F2242f4311A78D737d9234d79180116A81a42';

async function main() {
	const [deployer] = await ethers.getSigners();

	const RoyaltyEngineV1Contract = await ethers.getContractFactory('RoyaltyEngineV1');
	const royaltyEngineV1 = (await upgrades.deployProxy(RoyaltyEngineV1Contract, [ROYALTY_REGISTRY_ADDRESS], {
		initializer: '__RoyaltyEngineV1_init',
		kind: 'transparent'
	})) as RoyaltyEngineV1;
	await royaltyEngineV1.deployed();

	console.log(
		[
			`Deployed "RoyaltyEngineV1":` /**/, //
			` - to ${royaltyEngineV1.address}`,
			` - deployer address is ${deployer.address}`
		].join('\n')
	);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});
