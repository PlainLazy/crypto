select
    lower(hex(pubkey)) smesherId,
    diff deltaSU,
    round(diff*64/1000.0,2) deltaTiB
from (
    select
    t1.pubkey,
    t1.effective_num_units - t2.effective_num_units diff
    from (select pubkey, effective_num_units from atxs where epoch = 16) t1
    left join (select pubkey, effective_num_units from atxs where epoch = 15) t2 on t1.pubkey = t2.pubkey and t2.effective_num_units != t1.effective_num_units
)
where diff is not null and diff != 0
order by diff desc