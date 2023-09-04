--select sum(smh) from (
	select round(t2.balance/1000,3) smh, t1.l last_layer, t1.c updates
	from (
		select address a, max(layer_updated) l, count(*) c
		from accounts where layer_updated > 0 group by a
	) t1
	join accounts t2 on t1.a = t2.address and t1.l = t2.layer_updated
	order by t2.balance desc
--)
