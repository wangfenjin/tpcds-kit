tool:
	cd tools; make os=LINUX

gen1g:
	mkdir -p /tmp/tpcds-data/
	cd tools; ./dsdgen -DIR /tmp/tpcds-data -SCALE 1 -TERMINATE N, tpcds.sql
	rm /tmp/tpcds-data/dbgen_version.dat

genq:
	cd query_templates; sh update_query.sh
	bash genquery.sh
