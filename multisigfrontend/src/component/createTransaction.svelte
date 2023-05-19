<script>
    import { ethers } from "ethers";
  import { callContractFunction } from "../store/web3Function";

  export let amount = ""
  export let addressTo = ""
  const textStyle = 'text-white text-xl font-bold'

  

  const createTx = async ( ) =>{
    console.log({amount})

    console.log({addressTo})
    if(!amount || ! addressTo) return false;
    console.log({amount})

    console.log({addressTo})

    const data = ethers.encodeBytes32String("")

    
    try{
        await callContractFunction('createTransaction','Created', ["_from", "_to", "value"] , addressTo, ethers.parseEther(amount).toString(), data)
    }
    catch(error){
        console.error({error})
    }
  } 

</script>

<div class="flex flex-col gap-4 w-3/12 p-5">
    <h1 class={textStyle}>AMOUNT</h1>
    <input class=" rounded-md p-2" bind:value={amount} />

    <h1 class={textStyle}>ADDRESS</h1>
    <input class="rounded-md p-2" bind:value={addressTo} />

    
</div>
<button class="bg-white rounded-full p-4" on:click={() => {createTx()}}>Create Transaction</button>
