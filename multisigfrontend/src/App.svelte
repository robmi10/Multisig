<script>
  import CreateTransaction from "./component/createTransaction.svelte";
  import GetData from "./component/graphQL/getData.svelte";
  import Navbar from "./routes/+navbar.svelte";
  import {  account, isToaster } from "./store/web3";
  import toast, { Toaster } from 'svelte-french-toast';


  
  const textH1 = 'text-white text-5xl font-bold flex  flex-col justify-center drop-shadow-lg  items-center p-4'
  const textH2 = 'text-white text-2xl font-bold flex  flex-col justify-center drop-shadow-lg  items-center p-4'

  $:{
    if($isToaster.toaster && $isToaster.data == 'approve'){
      toast.success("Transaction is approved!")
      isToaster.set({ toaster: false, data: "" });
    }else if ($isToaster.toaster && $isToaster.data == 'sendTx'){
      toast.success("Transaction is sent!")
      isToaster.set({ toaster: false, data: "" });
    }
    else if ($isToaster.toaster && $isToaster.data == 'createTransaction'){
      toast.success("Transaction is created!")
      isToaster.set({ toaster: false, data: "" });
    }
  }
</script>

<main>
  <div class=" h-full w-screen p-10 bg-gradient-to-r from-cyan-200 to-blue-800  justify-center items-center flex gap-4 flex-col">
    <div class="w-full flex items-center justify-between md:p-5 md:w-2/4">
      <Navbar/>
      {#if $account}
      <h1 class="text-white font-bold">{$account.substring(0,12)}</h1>
      {/if}
    </div>
    <div class="w-full h-full p-4 flex-col  gap-4 items-center">
      <div class="md:float-left border-4 border-transparent drop-shadow-2xl rounded-xl justify-center gap-2  items-center flex flex-col md:w-2/4 h-[30vh]">
          <h1 class={textH1}>MultiSig App</h1>
          <h1 class={textH2}>Send and receive Ether</h1>
        </div>
        <div class="md:float-right md:w-2/4 flex items-center flex-col justify-around">
          <CreateTransaction/>
        </div>
    </div>
    <div class="w-full h-full flex items-center justify-center">
      <div class="hidden md:flex md:float-left border-4 border-transparent drop-shadow-2xl rounded-xl justify-center items-center  flex-col w-2/4 h-[45vh]">
        </div>
        <div class="md:float-right w-full md:w-2/4 flex items-center flex-col justify-around">
          <GetData/>
        </div>
    </div>
    <Toaster/>
  </div>
 
</main>

