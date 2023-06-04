<script>
  import CreateTransaction from "./component/createTransaction.svelte";
  import GetData from "./component/graphQL/getData.svelte";
  import Navbar from "./routes/+navbar.svelte";
  import {  account, isLoading, isToaster, web3Store } from "./store/web3";
  import toast, { Toaster } from 'svelte-french-toast';


  $: console.log({accountCheckNow: account})  
  const textH1 = 'text-white text-5xl font-bold flex  flex-col justify-center drop-shadow-lg  items-center p-4'
  const textH2 = 'text-white text-2xl font-bold flex  flex-col justify-center drop-shadow-lg  items-center p-4'

  $:{
    console.log("inside toaster check -> ", $isToaster.data)
    if($isToaster.toaster && $isToaster.data == 'approve'){
      console.log({isToasterApprover:  $isToaster.toaster})
      toast.success("Transaction is approved!")
      isToaster.set({ toaster: false, data: "" });
    }else if ($isToaster.toaster && $isToaster.data == 'sendTx'){
      console.log({isToasterSend:  $isToaster.toaster})
      toast.success("Transaction is sent!")
      isToaster.set({ toaster: false, data: "" });
    }
    else if ($isToaster.toaster && $isToaster.data == 'createTransaction'){
      // console.log({isToasterCreate:  $isToaster.toaster})
      console.log("isToasterCreate now")
      toast.success("Transaction is created!")
      isToaster.set({ toaster: false, data: "" });
      console.log({isToasterCreateSetTofalse:  $isToaster.toaster})
    }
  }
</script>

<main>
  <div class="h-full w-screen p-10 bg-gradient-to-r from-cyan-200 to-blue-800  justify-center items-center flex gap-4 flex-col">
    <div class="w-2/4 flex items-center justify-between p-5">
      <Navbar/>
      {#if $account}
      <h1 class="text-white font-bold">{$account.substring(0,12)}</h1>
      {/if}
    </div>
    <div class="w-full h-full p-4 flex gap-4 justify-center items-center ">
      <div class="float-left border-4 border-transparent drop-shadow-2xl rounded-xl justify-center gap-2  items-center flex flex-col w-2/4 h-[68vh]">
          <h1 class={textH1}>MultiSig App</h1>
          <h1 class={textH2}>Send and receive Ether</h1>
        </div>
        <div class=" float-right w-2/4 flex items-center flex-col gap-4">
          <CreateTransaction/>
          <GetData/>
        </div>
      
    </div>
    <Toaster/>
  </div>
 
</main>

