// utils.js
import { Contract, ethers } from "ethers";
import { get as getStoreValue } from "svelte/store";
import { account, web3Store } from "./web3";
import { CONTRACT_ADDRESS } from "../lib/constant/contract";
import { abi } from "../lib/constant/abi.js";

const contractAbi = abi;
const contractAddress = CONTRACT_ADDRESS;
let contract;
let currentAccount = getStoreValue(account);

console.log({ currentAccount });

$: console.log({ account });
console.log({ Insidesigner: currentAccount });
// const provider = new ethers.AlchemyProvider(
//   "maticmum",
//   "ehW3LHWYnuuGS10F0QGLh-A8Zh4Hf-5i"
// );
const provider = new ethers.BrowserProvider(window.ethereum);

console.log({ CheckProvider: provider });

// console.log({ signtest });

export async function callContractFunction(
  functionName,
  functionEvent,
  eventargs,
  ...args
) {
  const signtest = await provider.getSigner();
  // const signer = await provider.getSigner();
  console.log({ contractAddress });

  contract = new Contract(contractAddress, contractAbi, signtest);
  console.log({ contract });
  if (!contract) {
    console.error("Wallet is not connected");
    return;
  }

  console.log({ functionName });

  console.log({ args });

  const result = await contract[functionName](...args);

  contract.on(functionEvent, (...eventArgs) => {
    const event = eventArgs[eventArgs.length - 1];
    for (let i = 0; i < eventargs.length; i++) {
      console.log(`${eventargs[i]}: ${eventArgs[i]}`);
    }
    console.log("Transaction hash:", event.transactionHash);
  });

  console.log("Contract function result:", result);
}
