select
	*,
	round(h9_coins_share / h9_cap_share * 100, 2) h9_effectivity
from (
	select
		*,
		round(h9_coins / net_rewards * 100, 2) h9_coins_share
	from (
		select
			(select count(*) from layers where id >= 16128) e3_layers,
			(select round(sum(total_reward/1000000000),2) from rewards
				where layer >= e3_layer_from
			) net_rewards,
			(select round(sum(total_reward/1000000000), 2) from rewards
				where layer >= e3_layer_from and coinbase = h9_coinbase
			) h9_coins,
			(select round(h9_pib / net_pib * 100, 2)) h9_cap_share
		from (
			select
				*,
				(
					select
						round(sum(effective_num_units*64.0/1024/1024), 4)
					from atxs
					where
						epoch = 3 and
						coinbase = h9_coinbase and
						received < strftime('%s', '2023-09-04 10:00:00+03:00')*1e9
				) h9_pib
			from (
				select
					14.4 net_pib,  -- hardcode
					X'0000000022605B8DBF0F2F7B88A58223B6BF31ED20181220' h9_coinbase,
					16128 e3_layer_from
			)
		)
	)
)
