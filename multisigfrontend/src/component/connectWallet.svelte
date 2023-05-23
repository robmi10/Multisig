<script>
import {  account , connectWallet, disconnectWallet } from '../store/web3';
</script>


{#if !$account}
<button class="bg-white hover:drop-shadow-xl rounded-full p-4 hover:bg-slate-50 hover:transition-all hover: duration-500" on:click={connectWallet}>Connect Wallet</button>
{:else }
<button class="bg-white hover:drop-shadow-xl rounded-full p-4 hover:bg-slate-50 hover:transition-all hover: duration-500" on:click={disconnectWallet}>Disconnect Wallet</button>
{/if}

