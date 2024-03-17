import {http, Hex, encodeFunctionData} from '@flashbots/suave-viem';
import {getSuaveProvider, getSuaveWallet} from '@flashbots/suave-viem/chains/utils';
import {TransactionRequestSuave} from '@flashbots/suave-viem/chains/suave/types';
import {suaveRigil} from '@flashbots/suave-viem/chains'
import {KeyManagementAbi} from './abis';

const keyManagementContractAddress = "0xD22CA6bFf045D214a80919e3e32D98f17CCa01d8"

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

// test funding transaction
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

// submit initialize transaction
const initializeTx: TransactionRequestSuave = {
    to: keyManagementContractAddress,
    data: encodeFunctionData({
        abi: KeyManagementAbi,
        functionName: "initialize",
        args: []
    }),
    type: '0x43', // confidential request
    gas: 20000000n,
    gasPrice: 1000000000n,
    kettleAddress: "0xB5fEAfbDD752ad52Afb7e1bD2E40432A485bBB7F",
}
const initialize = await wallet.sendTransaction(initializeTx);
console.log('initialize tx', initialize)
const initializeReceipt = await suaveProvider.getTransactionReceipt({hash: initialize})
console.log('key receipt', initializeReceipt)

// submit key shares transaction
const keyTx: TransactionRequestSuave = {
    to: keyManagementContractAddress,
    data: encodeFunctionData({
        abi: KeyManagementAbi,
        functionName: "submitShares",
        args: [
            [1204783606085636997, 103724202957580040, 1308507809043217034]
        ]  
    }),
    type: '0x43', // confidential request
    gas: 20000000n,
    gasPrice: 1000000000n,
    kettleAddress: "0xB5fEAfbDD752ad52Afb7e1bD2E40432A485bBB7F",
}
const key = await wallet.sendTransaction(keyTx);
console.log('key tx', key)
const keyReceipt = await suaveProvider.getTransactionReceipt({hash: key})
console.log('key receipt', keyReceipt)

// reconstruct key transaction
const reconstructTx: TransactionRequestSuave = {
    to: keyManagementContractAddress,
    data: encodeFunctionData({
        abi: KeyManagementAbi,
        functionName: "reconstructResult",
        args: []  
    }),
    type: '0x43', // confidential request
    gas: 20000000n,
    gasPrice: 1000000000n,
    kettleAddress: "0xB5fEAfbDD752ad52Afb7e1bD2E40432A485bBB7F",
}
const reconstruct = await wallet.sendTransaction(reconstructTx)
console.log('reconstruct tx', reconstruct)
const reconstructReceipt = await suaveProvider.getTransactionReceipt({hash: reconstruct})
console.log('reconstruction receipt', reconstructReceipt)
