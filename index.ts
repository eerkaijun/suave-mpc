import {http, Hex, encodeFunctionData} from '@flashbots/suave-viem';
import {SuaveTxRequestTypes, getSuaveProvider, getSuaveWallet} from '@flashbots/suave-viem/chains/utils';
import {TransactionRequestSuave} from '@flashbots/suave-viem/chains/suave/types';
import {suaveRigil} from '@flashbots/suave-viem/chains'
import { StoreAbi } from './abis';

// connect to your local SUAVE node
const SUAVE_RPC_URL = 'http://localhost:8545';
const suaveProvider = getSuaveProvider(http(SUAVE_RPC_URL));

const DEFAULT_PRIVATE_KEY: Hex =
  '0x91ab9a7e53c220e6210460b65a7a3bb2ca181412a8a7b43ff336b3df1737ce12';
// const gasPrice = await publicClients.suaveLocal.getGasPrice();

const wallet = getSuaveWallet({
  transport: http(SUAVE_RPC_URL),
  privateKey: DEFAULT_PRIVATE_KEY,
});

console.log('Wallet Address:', wallet.account.address);

const fundTx: TransactionRequestSuave = {
    type: '0x0',
    value: 100000000000000001n,
    gasPrice: 10000000000000n,
    chainId: suaveRigil.id,
    to: wallet.account.address,
    gas: 21000n,
};

const fund = await wallet.sendTransaction(fundTx);
console.log('sent fund tx', fund);

const storeTx: TransactionRequestSuave = {
    to: "0xd594760B2A36467ec7F0267382564772D7b0b73c",
    data: encodeFunctionData({
        abi: StoreAbi,
        functionName: 'example',
        args: [],
    }),
    type: '0x43', // confidential request
    gas: 5000000n,
    gasPrice: 1000000000n,
    kettleAddress: "0xB5fEAfbDD752ad52Afb7e1bD2E40432A485bBB7F",
    //confidentialInputs: confidentialInput,
}
const store = await wallet.sendTransaction(storeTx);
console.log('store tx', store)