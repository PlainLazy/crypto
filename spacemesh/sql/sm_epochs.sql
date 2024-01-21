select
	*,
	round((select sum(effective_num_units)*64.0/1024/1024 from atxs where epoch = t1.epoch) - t1.network_pib,2) slowpoke_pib
from (
	select
	  epoch,
	  count(*) smeshers,
	  max(effective_num_units) biggest_u,
	  round(max(effective_num_units)*64.0/1024,2) biggest_tib,
	  round(sum(effective_num_units)*64.0/1024/1024,2) network_pib
	from atxs
	where epoch = 1 or
		(epoch = 2 and received < strftime('%s', '2023-08-21 10:00:00+03:00')*1e9) or
		(epoch = 3 and received < strftime('%s', '2023-09-04 10:00:00+03:00')*1e9)
	group by epoch
) t1
