default: all
all: results.tsv

help:
	echo "TODO: usage"

.PHONY: default all help

################################################################################

NETIDS_LIST = netids.txt
TESTS_LIST  = tests.txt

RESULTS_DIR     = results
SUBMISSIONS_DIR = submissions
TESTS_DIR       = tests

LOG_FILE = log.txt

################################################################################

SHELL = /bin/bash

$(RESULTS_DIR):
	mkdir -p $@

.pairs.make: Makefile $(NETIDS_LIST) $(TESTS_LIST)
	echo "# Automatically generated; do not edit" > $@
	echo "# for each (student,test) pair on the test, contains the result: test dependency" >> $@
	results_list="RESULTS_LIST = "; \
	for netid in $$(cat $(NETIDS_LIST)); do \
		for test in $$(cat $(TESTS_LIST)); do \
			result="$(RESULTS_DIR)/$${netid}-$${test}.line"; \
			results_list="$${results_list} $${result}"; \
			echo "$${result}: $(TESTS_DIR)/$${test}" >> $@; \
		done \
	done; \
	echo "" >> $@; \
	echo "$${results_list}" >> $@; \
	echo "" >> $@

include .pairs.make

results/%.line: $(RESULTS_DIR)
	netid=$$(basename $@ .line | sed 's/\([^-]*\)-\(.*\)/\1/'); \
	test=$$(basename $@ .line | sed 's/\([^-]*\)-\(.*\)/\2/');  \
	cd $(SUBMISSIONS_DIR)/$${netid}; \
		echo -ne $${netid}\\t$${test}; \
		../../$(TESTS_DIR)/$${test} > /dev/null 2> $(LOG_FILE); \
		case $$? in \
			0)   result=PASS ;; \
			124) result=TIMEOUT ;; \
			*)   result=FAIL ;; \
		esac; \
		echo -e \\t$${result}; \
	cd -; \
	echo -e $$(date +'%s')\\t$${netid}\\t$${test}\\t$${result} | tee $@

results.tsv: $(RESULTS_LIST)
	echo -e Timestamp\\tNetID\\tTest\\tResult | cat - $^ > $@


