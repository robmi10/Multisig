// utils.js
import { Contract, ethers } from "ethers";
import { get as getStoreValue } from "svelte/store";
import { account, web3Store } from "./web3";
import { CONTRACT_ADDRESS } from "../lib/constant/contract";
import { abi } from "../lib/constant/abi.js";
import { isLoading } from "../store/web3";

const contractAbi = abi;
const contractAddress = CONTRACT_ADDRESS;
let contract;
let currentAccount = getStoreValue(account);

console.log({ currentAccount });

$: console.log({ account });
const provider = new ethers.BrowserProvider(window.ethereum);

export async function callContractFunction(
  functionName,
  functionEvent,
  eventargs,
  value,
  ...args
) {
  const signtest = await provider.getSigner();

  contract = new Contract(contractAddress, contractAbi, signtest);
  console.log({ contract });
  if (!contract) {
    console.error("Wallet is not connected");
    return;
  }

  console.log({ functionName });
  console.log({ args });
  console.log({ value });

  const result = value
    ? await contract[functionName](...args, {
        value: ethers.parseEther(value.toString()),
      })
    : await contract[functionName](...args);

  contract.on(functionEvent, (...eventArgs) => {
    const event = eventArgs[eventArgs.length - 1];
    for (let i = 0; i < eventargs.length; i++) {
      console.log(`${eventargs[i]}: ${eventArgs[i]}`);
    }
    console.log("Transaction hash:", event.transactionHash);

    isLoading.set({ functionStatus: "", data: null });
  });

  console.log("Contract function result:", result);
}
