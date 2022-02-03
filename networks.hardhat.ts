import type { NetworksUserConfig } from 'hardhat/types';

export const networks: NetworksUserConfig = {
	hardhat: {},
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
		url: 'https://rinkeby.boba.network/'
	}
};
