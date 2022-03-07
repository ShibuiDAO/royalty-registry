import type { NetworksUserConfig } from 'hardhat/types';
import { testnetPrivateKey } from './config.hardhat';

export const networks: NetworksUserConfig = {
	hardhat: {
		accounts: {
			mnemonic:
				'fold taxi business smoke clap flash jewel doll path clutch switch valid stone clinic leopard tongue arrow pave stomach harbor tissue wing chapter adapt'
		}
	},
	frame: {
		url: 'http://127.0.0.1:1248'
	},
	local: {
		chainId: 99,
		url: 'http://127.0.0.1:8545',
		allowUnlimitedContractSize: true
	},
	localh: {
		chainId: 31337,
		url: 'http://127.0.0.1:8545',
		allowUnlimitedContractSize: true
	},
	boba: {
		url: 'https://mainnet.boba.network/'
	},
	bobaRinkeby: {
		url: 'https://rinkeby.boba.network/',
		accounts: [testnetPrivateKey]
	}
};
