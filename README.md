The Autograder
==============

This is a general purpose tool for running each of several tests against each
of several students, and summarizing the results.

Setup
-----

    submissions/abc12
               /xyz34
    tests/A-hardtest
         /B-mediumtest1
         /B-mediumtest2
         /B-mediumtest3
         /C-easytest
         /C-anothereasytest
    students.txt:
         abc12
         xyz34
    tests.txt:
         A-hardtest
         C-mediumtest

The `bin` directory should also be present, unless you add `pivot` and `pad` to
your `PATH`.

Each test should be an executable file in the `tests/`
directory; the filename should be LEVEL-name (for example
A-hardtest or C-compiles).

The tests you actually want to run should be listed in the file tests.txt.  It
is useful to change this file if you want to just focus on one test).

The student submissions should be stored in folders in the submissions/
directory (e.g. submissions/xyz12/code.ml).

The netids of the students you actually want to test should be listed in
students.txt.


Running
-------

Run `make` to run all tests against all students.  Tests will
/not/ be rerun unless the test itself changes; you can touch a
test to force it to be rerun.

The standard error from each test execution will be appended to the file
log.txt in the student's submission directory.

each test results will be output in a file in the results/
folder; when all tests have been run, the results will be
summarized in several .tsv files in the top directory.

### Running tests in parallel

See the -j and -l options to make.


Output
------

### `results/`

Contains a file `<netid>-<test>.line` with the results of each test.

### `submissions/<netid>/log.txt`

Contains the standard output from each test run.

### `results.tsv`

A tsv file containing the raw data (just concatenated from `results/*`)

### `test_summary.tsv`

A table listing all of the tests, along with the pass/fail/timeout ratios for
each.  Useful for debugging tests.  This file is also displayed after `make` is run.

### `stud_summary.tsv`

A table listing, for each student, the number of tests that pass/fail/timeout.

### `stud_detail.tsv`

A table listing, for each student and each test, the pass/fail/timeout results.

### `*.csv`

If you prefer `csv` over `tsv` output, the `Makefile` will automatically convert
them for you, just update the `report` target to depend on `csv`
the files instead.



