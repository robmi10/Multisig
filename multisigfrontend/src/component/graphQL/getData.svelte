<script>
  import { ethers } from "ethers";
  import { callContractFunction } from "../../store/web3Function";
  import { flip } from 'svelte/animate';
  import { crossfade } from "svelte/transition";
  import { quintOut } from 'svelte/easing';
  import { Circle } from 'svelte-loading-spinners';
  import { isLoading } from "../../store/web3";


  let data;

  const textStyle = 'text-white text-md font-bold w-26'
  const texth1 = 'text-white text-md w-16'
  const [send, receive] = crossfade({
		fallback(node, params) {
			const style = getComputedStyle(node);
			const transform = style.transform === 'none' ? '' : style.transform;

			return {
				duration: 600,
				easing: quintOut,
				css: t => `
					transform: ${transform} scale(${t});
					opacity: ${t}
				`
			};
		}
	});
  
  const fetchEvents = async () => {
    try {
      const response = await fetch('https://api.studio.thegraph.com/query/47164/multisig10/version/latest', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: JSON.stringify({
            query: `{
                      createds(first: 1000) {
                        id
                        _from
                        _to
                        counter
                        data
                        value
                        blockNumber
                        blockTimestamp
                        transactionHash
                      }
                      approves( first: 1000) {
                        id
                        _from
                        _to
                        counter
                        _approver
                        _amount
                        blockNumber
                        blockTimestamp
                        transactionHash
                      }
                      
                      sends(first: 1000) {
                        id
                        _from
                        _to
                        counter
                        value
                        blockNumber
                        blockTimestamp
                        transactionHash
                      }
                    }
                  `
        })
      })
      
      const res = await response.json()
      // data = res.data.transactions
      console.log({res})
      console.log({data})

      let createds = res?.data?.createds
      let approves = res?.data?.approves
      let send = res?.data?.sends

      console.log({createds})

      const groupData = createds.reduce((map, created) =>{
        map[created?.counter] = {
          created,
          approves: approves?.filter(approve => approve?.counter === created?.counter),
          send: send?.filter(send => send?.counter === created?.counter)
        };
        return map;
      }, {})

      const groupDataArray = Object.values(groupData);

      
      console.log({groupDataArray})
      data = groupDataArray

    } catch (error) {
      console.error({error})
    }

    
  }
  
  fetchEvents()

  const sendTransaction = async(id) =>{
      try {
          await callContractFunction('sendTx','Created', ["_from", "_to"] , id)
          isLoading.set({functionStatus: 'sendTx', data: id})
      } catch (error) {
          console.error({error})
      }
    }

    const approve = async(id) =>{
    try {
        await callContractFunction('approve','Approve', ["_from", "_to", "_amount", "_approver"] , false, id)
        isLoading.set({functionStatus: 'approve', data: id})
        console.log({approveIsloading: $isLoading})
    } catch (error) {
        console.error({error})
    }
  }

  

  
  let combinedArray = data ? Object.values(data) : []


  console.log({combinedArray})
  </script>
  
  <div class="w-full overflow-auto p-8 drop-shadow-lg flex items-center justify-center flex-col">
    {#if data}
    {#each data as transaction, index (transaction.created.id)  }
    <div class="mb-4 drop-shadow-xl border-1 w-full bg-gradient-to-r from-blue-300 via-cayan-300 to-white-300 items-center flex justify-center gap-8 rounded-md p-4 hover:bg-gradient-to-r hover:from-blue-400 hover:via-cayan-400 hover:to-white-400 hover:transition-all"
    in:receive="{{key: transaction.id}}"
    out:send="{{key: transaction.id}}"
    animate:flip
    >
      <div>
        <h1 class={textStyle}>FROM</h1>
        <h1 class={texth1}> {transaction.created._from.substring(0, 8)}</h1>
      </div>
      <div>
        <h1 class={textStyle}>TO</h1>
        <h1 class={texth1}>{transaction.created._to.substring(0, 8  )}</h1>
      </div>
      <div>
        <h1 class={textStyle}>AMOUNT</h1>
        <div class="flex gap-1">
          <h1 class={texth1}>{ethers.formatEther(transaction.created.value.toString())}</h1>
          <h1 class={texth1}>MATIC</h1>
        </div>
      </div>
  
     <div>
        <h1 class={textStyle}>APPROVED</h1>
        <h1 class={texth1}>{transaction?.approvals?.length || 0}</h1>
      </div>
      {#if transaction.approved == 2}
      <button class="bg-white rounded-full w-36 p-4" on:click={() => {sendTransaction(index)}}>Send</button>
      {:else if $isLoading.data == index}
      <button class="bg-white rounded-full w-36 p-4 flex justify-center" on:click={() => {sendTransaction(index)}}>    
        <Circle size="25" color="#3b86ff" unit="px" duration="1s" />
      </button>
      {:else }
      <button class="bg-white rounded-full w-36 p-4 hover:drop-shadow-lg hover:bg-slate-50" on:click={() => {approve(transaction.created.id)}}>Approve</button> 
      {/if} 
    </div>
      
    {/each}
    {/if}
  </div>  