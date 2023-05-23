// web3Store.js
import { writable } from "svelte/store";
import { ethers } from "ethers";

const initialWeb3Props = {
  signer: null,
  provider: null,
  account: null,
  //   chainId: null,
};

export const isLoading = writable({ functionStatus: "", data: null });

export const web3Store = writable(initialWeb3Props);

function createLocalStorageStore(key, startValue) {
  const storedValue = localStorage.getItem(key);
  const initialValue = storedValue ? storedValue : startValue;

  const { subscribe, set } = writable(initialValue);

  return {
    subscribe,
    set: (value) => {
      console.log("inside set now");
      localStorage.setItem(key, value);
      set(value);
    },
    reset: () => {
      localStorage.removeItem(key);
      set(startValue);
    },
  };
}

export const account = createLocalStorageStore("account", "");

export async function connectWallet() {
  const provider = new ethers.BrowserProvider(window.ethereum);
  const accounts = await provider.send("eth_requestAccounts", []);
  const signer = provider.getSigner();
  const getAccount = await accounts[0];

  console.log("inside connectWallet");

  console.log({ signer: getAccount });

  console.log({ insideGetaccount: getAccount });
  account.set(getAccount);

  web3Store.set({ signer, provider, account });
}

export function disconnectWallet() {
  console.log("disconnecting wallet");

  // Clear the account in localStorage
  account.reset();

  // Reset the web3Store
  web3Store.set(initialWeb3Props);
}
