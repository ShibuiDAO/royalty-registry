import '@nomiclabs/hardhat-ethers';
import '@nomiclabs/hardhat-solhint';
import '@nomiclabs/hardhat-waffle';
import '@openzeppelin/hardhat-upgrades';
import '@typechain/hardhat';
import 'hardhat-abi-exporter';
import 'hardhat-deploy';
import 'hardhat-gas-reporter';
import 'hardhat-tracer';
import { HardhatUserConfig, task } from 'hardhat/config';
import 'solidity-coverage';
import { networks } from './networks.hardhat';

task('accounts', 'Prints the list of accounts', async (_, hre) => {
	const accounts = await hre.ethers.getSigners();

	for (const account of accounts) {
		console.log(account.address);
	}
});

const config: HardhatUserConfig = {
	paths: {
		root: './',
		sources: './src/contracts',
		tests: './test'
	},
	solidity: {
		version: '0.8.9',
		settings: {
			optimizer: {
				enabled: true,
				runs: 1000000
			},
			metadata: { useLiteralContent: true },
			outputSelection: {
				'*': {
					'*': ['storageLayout']
				}
			}
		}
	},
	defaultNetwork: 'hardhat',
	networks,
	abiExporter: {
		path: './abis',
		runOnCompile: true,
		clear: true,
		flat: true,
		only: ['RoyaltyRegistry.sol']
	},
	gasReporter: {
		showTimeSpent: true,
		currency: 'EUR',
		gasPrice: 1
	}
};

export default config;
