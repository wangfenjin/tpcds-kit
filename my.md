### Presto: Update to the generated query

1. Split query_14 to a and b as it's two query
2. Fix days: sed -i "s/+ \([0-9]\+\) days/+ interval '\1' day/g" *.sql
