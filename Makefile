default: report
all: results.tsv

help:
	echo "TODO: usage"

report: test_summary.tsv stud_summary.tsv stud_detail.csv
	echo ""
	echo "RESULTS:"
	bin/pad test_summary.tsv


clean:
	git clean -fdX

.PHONY: default all help report
.SILENT:

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
		echo === $${test} === >> $(LOG_FILE); \
		date >> $(LOG_FILE); \
		../../$(TESTS_DIR)/$${test} > /dev/null 2>> $(LOG_FILE); \
		case $$? in \
			0)   result=PASS ;; \
			124) result=TIMEOUT ;; \
			*)   result=FAIL ;; \
		esac; \
		echo $${result} >> $(LOG_FILE); \
		echo "" >> $(LOG_FILE); \
	cd ../../; \
	pwd; \
	echo -e $$(date +'%s')\\t$${netid}\\t$${test}\\t$${result} | tee $@

%.csv: %.tsv
	sed 's/\t/,/g' $^ > $@

results.tsv: $(RESULTS_LIST) $(NETIDS_LIST) $(TESTS_LIST)
	echo -e Timestamp\\tNetID\\tLevel\\tTest\\tResult \
		| cat - $(RESULTS_LIST) \
		| sed 's/-/\t/g' \
		> $@


test_summary.tsv: results.tsv
	bin/pivot -r Level -r Test -c Result -v NetID < $< > $@

stud_summary.tsv: results.tsv
	bin/pivot -r NetID -c Result -v Test < $< > $@

stud_detail.tsv: results.tsv
	bin/pivot -r NetID -r Level -r Test -c Result -v Test < $< > $@

