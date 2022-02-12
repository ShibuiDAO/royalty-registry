import { ethers } from 'hardhat';

const OVERRIDE_ASSET = process.env.OVERRIDE_ASSET || '';
const COLLECTION_OWNER = process.env.COLLECTION_OWNER || '';

async function main() {
	const [deployer] = await ethers.getSigners();

	const ERC2981RoyaltyOverrideContract = await ethers.getContractFactory('ERC2981RoyaltyOverride');
	const erc2981RoyaltyOverride = await ERC2981RoyaltyOverrideContract.deploy(OVERRIDE_ASSET);
	await erc2981RoyaltyOverride.deployed();

	await erc2981RoyaltyOverride.setRoyaltyRecipient(COLLECTION_OWNER);
	await erc2981RoyaltyOverride.transferOwnership(COLLECTION_OWNER);

	console.log(
		[
			`Deployed "ERC2981RoyaltyOverride":` /**/, //
			` - to ${erc2981RoyaltyOverride.address}`,
			` - asset of address ${await erc2981RoyaltyOverride.asset()}`,
			` - set owner address is ${await erc2981RoyaltyOverride.owner()}`,
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
