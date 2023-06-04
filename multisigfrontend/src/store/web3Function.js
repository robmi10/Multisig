// utils.js
import { Contract, ethers } from "ethers";
import { get as getStoreValue } from "svelte/store";
import { account, isToaster, web3Store } from "./web3";
import { CONTRACT_ADDRESS } from "../lib/constant/contract";
import { abi } from "../lib/constant/abi.js";
import { isLoading } from "../store/web3";

const contractAbi = abi;
const contractAddress = CONTRACT_ADDRESS;
let contract;
let currentAccount = getStoreValue(account);

console.log({ currentAccount });

// $: console.log({ account });
const provider = new ethers.BrowserProvider(window.ethereum);

export async function callContractFunction(
  functionName,
  functionEvent,
  eventargs,
  value,
  ...args
) {
  return new Promise(async (resolve, reject) => {
    const signtest = await provider.getSigner();

    console.log({
      functionName: functionName,
      args: args,
      eventargs: eventargs,
    });

    contract = new Contract(contractAddress, contractAbi, signtest);
    console.log({ contract });
    if (!contract) {
      console.error("Wallet is not connected");
      return reject("Wallet is not connected");
    }

    console.log({ functionName });
    console.log({ args });
    console.log({ value });

    const result = value
      ? await contract[functionName](...args, {
          value: ethers.parseEther(value.toString()),
        })
      : await contract[functionName](...args);

    const handler = (...eventArgs) => {
      const event = eventArgs[eventArgs.length - 1];
      for (let i = 0; i < eventargs.length; i++) {
        console.log(`${eventargs[i]}: ${eventArgs[i]}`);
        console.log("inside function loop", i);
      }
      console.log("Transaction hash:", event.transactionHash);

      // Now that the event has been handled, remove the listener
      contract.removeListener(functionEvent, handler);
      console.log("Contract before contract on", result);
      isToaster.set({ toaster: true, data: functionName.toString() });
      resolve(result);
    };

    contract.on(functionEvent, handler);

    console.log("Contract function result:", result);
    isLoading.set({ functionStatus: functionName, data: args[0] });

    return result;
  });
}
