declare @object_code varchar(100);
set @object_code = '3100,3102,3105';

select
    ltrim(rtrim(x.par.value('.[1]','varchar(max)'))) as object_code
from (
    select convert(xml,'<params><param>' + replace(@object_code,',', '</param><param>') + '</param></params>') as c
) tbl
cross apply
    c.nodes('/params/param') x(par);
