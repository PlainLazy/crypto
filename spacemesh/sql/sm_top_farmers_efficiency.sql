select
    *,
    round(rewards_share / space_share * 100) effectivity
from (
    select
        *,
        round(TiB_farmer / PiB_total * 100, 4) space_share,
        round(rewards_farmer / rewards_total * 100, 4) rewards_share
    from (
        select * from (
            select
                count(*) nodes,
                ( select round(sum(effective_num_units*64.0/1024)) from atxs where epoch = 3 ) PiB_total,
                round(sum(effective_num_units*64.0/1024)) TiB_farmer,
                ( select round(sum(total_reward/1000000000.0)) from rewards where layer >= 16128 ) rewards_total,
                ( select round(sum(total_reward/1000000000.0)) from rewards where layer >= 16128 and coinbase = atxs.coinbase ) rewards_farmer
            from atxs where epoch=3 group by coinbase
        ) order by TiB_farmer desc limit 30
    ) t1
)
