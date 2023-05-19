<script>
import {  account , connectWallet, disconnectWallet } from '../store/web3';
</script>


{#if !$account}
<button class="bg-white rounded-full p-4" on:click={connectWallet}>Connect Wallet</button>
{:else }
<button class="bg-white rounded-full p-4" on:click={disconnectWallet}>Disconnect Wallet</button>
{/if}

