// use in console https://astral.autonomys.xyz/
(async function(acc,hours){
  await fetch('//subql.green.mainnet.subspace.network/v1/graphql', {method:'POST', body:JSON.stringify({
   operationName: "AccountById",
   variables: {accountId:acc},
   query: `query AccountById($accountId: String!) {consensus_rewards(limit: 15000 order_by: {block_height: desc} where: {account_id: {_eq: $accountId}, amount: {_gt: 0}, timestamp: {_gt: "${new Date(Date.now()-hours*60*60*1000).toISOString()}"}}) {rewardType: reward_type amount}}`})
  }).then(async r => {
   const rews = (await r.json()).data.consensus_rewards
   const rnd = (v) => Math.round(v*100)/100
   const sum = (l) => rnd(l.reduce((a,v)=>a+Number(v.amount),0)/1e18)
   const blks = rews.filter(t => t.rewardType!=="rewards.VoteReward")
   console.log(`Received in the last ${hours}h: ${rews.length} rewards ${sum(rews)}(AI3), including ${sum(blks)}(AI3) from ${blks.length}(${rnd(blks.length/rews.length*100)}%) blocks`)
  })
})
('sudAj4uWBT6NSNUURqyDGGpFd7RvyytpLszfKuDtJovBrzmbG', 24)