// eslint-disable-next-line @typescript-eslint/no-var-requires
require('dotenv').config();
import { z } from 'zod';

const coinMarketCapApiSchema = z.string();
export const coinMarketCapApi = coinMarketCapApiSchema.parse(process.env.COINMARKETCAP_API);

const testnetPrivateKeySchema = z.string();
export const testnetPrivateKey = `${testnetPrivateKeySchema.parse(process.env.TESTNET_PRIVATE_KEY)}`;
