<script>
  import { callContractFunction } from "../store/web3Function";
  export let id = ""
  const textStyle = 'text-black text-xl font-bold'


  const approve = async() =>{
    try {
        await callContractFunction('approve','Approve', ["_from", "_to", "status"] ,id)
    } catch (error) {
        console.error({error})
    }

  }

</script>

<div class=" bg-blue-300 w-full flex items-center justify-center flex-col p-4">

  <div class="flex flex-col gap-4 w-3/12 p-5">
    <h1 class={textStyle}>Approve Transaction</h1>
    <input class=" rounded-md p-2" bind:value={id} />
  
  </div>
  <button class="bg-white rounded-full w-36 p-4" on:click={() => {approve()}}>Approve</button>
  
</div>