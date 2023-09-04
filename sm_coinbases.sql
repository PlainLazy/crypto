select * from (
	select
		hex(coinbase),
		count(*) cnt,
		round(sum(effective_num_units*64.0/1024), 2) tib
	from atxs
	where epoch = 3
	group by coinbase
) order by cnt desc
