TODO

- ansible : переписать плейбуки, чтобы они не разворачивали инфру по новой каждый раз + написать вроверки на все возможные кейсы (вектор, конфиги и прочее)
- stub : сделать логгирование ???
- ansible : рефакторинг
- elasticsearch : сделать настраивать политики хранения логов на 1 час
- отказаться от графаны, тут она не нужна по сути, в другой проект ее : переименовать tower towr
- добиться получения NXDOMAIN и прочего от bind
- делать автоматические сбои по таймауту ???


---

10-Jan-2026 06:09:18.023 queries: info: client @0x7f292b669c98 10.0.0.26#44743 (unknown.subdomain.domain.auto.internal): query: unknown.subdomain.domain.auto.internal IN AAAA +E(0) (10.0.0.34)
10-Jan-2026 06:09:18.023 queries: info: client @0x7f292d49ec98 10.0.0.26#47491 (unknown.subdomain.domain.auto.internal): query: unknown.subdomain.domain.auto.internal IN A +E(0) (10.0.0.34)
10-Jan-2026 06:09:18.023 resolver: debug 1: fetch: unknown.subdomain.domain.auto.internal/AAAA
10-Jan-2026 06:09:18.023 resolver: debug 1: fetch: unknown.subdomain.domain.auto.internal/A
10-Jan-2026 06:09:18.023 resolver: debug 1: fetch: auto.internal/NS
10-Jan-2026 06:09:18.023 resolver: debug 1: fetch: auto.internal/NS
10-Jan-2026 06:09:18.123 queries: info: client @0x7f292b669c98 10.0.0.26#47597 (wwa.subdomain.domain): query: wwa.subdomain.domain IN A +E(0) (10.0.0.34)
10-Jan-2026 06:09:18.123 resolver: debug 1: fetch: wwa.subdomain.domain/A
10-Jan-2026 06:09:18.123 resolver: debug 1: fetch: wwa.subdomain.domain/AAAA

10-Jan-2026 06:15:46.311 query-errors: info: client @0x7f292b668098 10.0.0.26#35605 (www.subdomain.domain): query failed (operation canceled) for www.subdomain.domain/IN/AAAA at query.c:7898
10-Jan-2026 06:15:46.311 query-errors: info: client @0x7f292d4a2498 10.0.0.26#45043 (www.subdomain.domain): query failed (operation canceled) for www.subdomain.domain/IN/AAAA at query.c:7898
10-Jan-2026 06:15:46.311 query-errors: info: client @0x7f292d429098 10.0.0.26#40849 (www.subdomain.domain): query failed (operation canceled) for www.subdomain.domain/IN/A at query.c:7898
10-Jan-2026 06:15:46.311 query-errors: info: client @0x7f292d49ec98 10.0.0.26#37104 (www.subdomain.domain): query failed (operation canceled) for www.subdomain.domain/IN/A at query.c:7898

# classical queries req

--- "%{log_date} %{log_time}.${} %{log_category}: "

SG bastion
  ingress
    TCP 22    from  0.0.0.0/0     # ssh to bastion
  egress
    TCP 22    to    SUBNET        # ssh jump to subnet hosts
    UDP 53    to    0.0.0.0/0     # apt resolve repos domain names
    TCP 80    to    0.0.0.0/0     # apt updates
    TCP 443   to    0.0.0.0/0     # apt updates

SG monitoring
  ingress
    TCP 22    from  SG bastion    # accept ssh jumps from bastion
    TCP 5601  from  0.0.0.0/0     # kibana GUI
    ANY --    from  SG internal   # communication with internal hosts
  egress
    UDP 53    to    0.0.0.0/0     # apt resolve repos domain names
    TCP 80    to    0.0.0.0/0     # apt updates
    TCP 443   to    0.0.0.0/0     # apt updates
    ANY --    to    SG internal   # communication with internal hosts

SG internal
  ingress
    TCP 22    from  SG bastion    # accept ssh jumps from bastion
    UDP 53    from  SUBNET        # dns zone transfer : root, tld, authoritative, recursive
    TCP 53    from  SUBNET        # dns requests : root, tld, authoritative, recursive
    ANY --    from  SG monitoring # monitoring
  egress
    UDP 53    to    SUBNET        # dns zone transfer : root, tld, authoritative, recursive
    TCP 53    to    SUBNET        # dns requests : root, tld, authoritative, recursive
    UDP 53    to    0.0.0.0/0     # apt resolve repos domain names
    TCP 80    to    0.0.0.0/0     # apt updates
    TCP 443   to    0.0.0.0/0     # apt updates
    ANY --    to    SG monitoring # monitoring