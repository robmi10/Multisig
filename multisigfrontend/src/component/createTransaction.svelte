<script>
  import { ethers } from "ethers";
  import { callContractFunction } from "../store/web3Function";
  export let amount = ""
  export let addressTo = ""
  import { Circle } from 'svelte-loading-spinners';
  import { isLoading } from "../store/web3";

  const headerStyle = 'text-white text-2xl font-bold'
  const textStyle = 'text-white text-md font-bold'

  $: console.log({$isLoading})

  const createTx = async ( ) =>{
    console.log({amount})
    console.log({addressTo})
    if(!amount || ! addressTo) return false;
    console.log({amount})
    console.log({addressTo})
    const data = ethers.encodeBytes32String("")

    try{
        await callContractFunction('createTransaction','Created', ["_from", "_to", "value"], amount, addressTo, ethers.parseEther(amount).toString(), data)
        isLoading.set({functionStatus: 'createTransaction', data: null})
        console.log({isLoadingCeck: $isLoading})
    }
    catch(error){
        console.error({error})
    }

  } 

</script>

  <div  class=" animate-fade transition-all rounded-xl w-full flex items-center justify-center flex-col p-4 drop-shadow-md" >
    
  <h1 class={headerStyle}>Create a transaction</h1>
  
<div class="flex flex-row gap-4  p-5">
  <div >
    <h1 class={textStyle}>AMOUNT</h1>
    <input  class=" drop-shadow-lg rounded-md p-2" bind:value={amount} />
  </div>

  <div>
    <h1 class={textStyle}>ADDRESS</h1>
    <input class=" drop-shadow-lg rounded-md p-2" bind:value={addressTo} />
  </div>
</div>

{#if $isLoading.functionStatus == 'createTransaction'}
<button class=" bg-white hover:drop-shadow-xl rounded-full hover:bg-slate-50 hover:transition-all hover: duration-500 w-36 p-4 flex justify-center" on:click={() => {createTx()}}>	
  <Circle size="25" color="#3b86ff" unit="px" duration="1s" />
</button>
  {:else}
  <button class=" bg-white hover:drop-shadow-xl rounded-full hover:bg-slate-50 hover:transition-all hover: duration-500 w-36 p-4" on:click={() => {createTx()}}>Create</button>
{/if}
</div>

