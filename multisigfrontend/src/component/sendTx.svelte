<script>
  import { crossfade, fade } from "svelte/transition";
    import { callContractFunction } from "../store/web3Function";
  // import { crossfade } from "svelte/transition";
    export let id = ""
    const textStyle = 'text-white text-md font-bold'
    const texth1 = 'text-white'

    const testList  = [
    {from: "0x2123", to: "0x3434", value: "2", approved: 0 },
    {from: "0x2123", to: "0x3434", value: "4", approved: 0 },
    {from: "0x2123", to: "0x3434", value: "5", approved: 2 }
    ]
  
    const sendTransaction = async() =>{
      try {
          await callContractFunction('sendTx','Created', ["_from", "_to"] , id)
      } catch (error) {
          console.error({error})
      }
    }
  </script>


<div class="w-full drop-shadow-lg  rounded-xl flex items-center justify-center flex-col p-4">

  {#each testList as data (data)}
  <div transition:fade class="mb-4 drop-shadow-lg w-3/4 items-center flex justify-center gap-8 rounded-md p-4 ">
    <div>
      <h1 class={textStyle}>FROM</h1>
      <h1 class={texth1}>{data.from}</h1>
    </div>
    <div>
      <h1 class={textStyle}>TO</h1>
      <h1 class={texth1}>{data.to}</h1>
    </div>
    <div>
      <h1 class={textStyle}>AMOUNT</h1>
      <h1 class={texth1}>{data.value}</h1>
    </div>

    <div>
      <h1 class={textStyle}>APPROVED</h1>
      <h1 class={texth1}>{data.approved}</h1>
    </div>
    {#if data.approved == 2}
    <button class="bg-white hover:drop-shadow-xl rounded-full hover:bg-slate-50 hover:transition-all hover: duration-500 animate-bounce w-36 p-4" on:click={() => {sendTransaction()}}>Send</button>
    {:else }
    <button class="bg-white hover:drop-shadow-xl rounded-full hover:bg-slate-50 hover:transition-all hover: duration-500  w-36 p-4" on:click={() => {sendTransaction()}}>Approve</button> 
    {/if}
  </div>
    
  {/each}

  
  </div>
  