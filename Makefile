default: all
all: results.tsv

help:
	echo "TODO: usage"

.PHONY: default all help

NETIDS_LIST = netids.txt
TESTS_LIST  = tests.txt

RESULTS_DIR     = results
SUBMISSIONS_DIR = submissions
TESTS_DIR       = tests

LOG_FILE = log.txt

.ONESHELL:
SHELL = /bin/bash

RESULTS_LIST = $(foreach netid,$(NETIDS_LIST),$(foreach test,$(TESTS_LIST),results/$(netid)-$(test).line))

$(RESULTS_DIR):
	mkdir -p $@

.pairs.make: $(NETIDS_LIST) $(TESTS_LIST)
	

results/%.line: $(RESULTS_DIR)
	netid=$$(basename $@ .line | sed 's/\(.*\)-\(.*\)/\1/')
	test=$$(basename $@ .line | sed 's/\(.*\)-\(.*\)/\2/')
	cd $(SUBMISSIONS_DIR)/$${netid}
		echo -ne $${netid}\\t$${test}
		../../$(TESTS_DIR)/$${test} > /dev/null 2> $(LOG_FILE) in
		case $? in
			0)   result=PASS ;;
			124) result=TIMEOUT ;;
			*)   result=FAIL ;;
		esac
		echo -e \\t$${result}
	cd -
	echo -e $$(date -'%s')\\t$${netid}\\t$${test}\\t$${result} | tee $@

results.tsv: $(RESULTS_LIST)
	echo -e Timestamp\\tNetID\\tTest\\tResult | cat - $^ >> $@


