<script>
  import CreateTransaction from "./component/createTransaction.svelte";
  import Navbar from "./routes/+navbar.svelte";
  import {  account, web3Store } from "./store/web3";
  

  $: console.log({accountCheckNow: account})

  
  const textStyle = 'text-white text-xl font-bold'
</script>

<main>
  <div class=" w-screen bg-red-400 h-screen justify-center items-center flex gap-4 flex-col">
    <div class=" w-2/4 flex items-center justify-between p-5">
      <Navbar/>
      {#if $account}
      <h1 class={textStyle}>{$account}</h1>
      {/if}
    </div>

    <CreateTransaction/>
    
    <div class={textStyle}>

        <h1>MultiSig Wallet</h1>
        <h1>Send and receive Ether</h1>
      
    </div>
  </div>
 
</main>

