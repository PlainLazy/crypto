select
	sum(t2.balance)/1000000000 total_supply
from (
	select
		address a, max(layer_updated) l
	from accounts
	where layer_updated > 0
	group by a
) t1
	join accounts t2
	on t1.a = t2.address and t1.l = t2.layer_updated
