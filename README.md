# voyager-opac-load-test
Scripts and other resources for running Voyager OPAC load tests

Very QAD script at present, just enough to throw arbitrary load at the (Tomcat-based) OPAC.

Assumes there's a directory called searchterms containing files called gkey_searchterms.00 through gkey_searchterms.59 .

Use gkey_searchterms.sql to get large file of terms from search logs; split into 60 files named as above.

Example: to run 20 searches, started 2 seconds apart:
$ for test in $(seq 20); do sleep 2; ./opactest.sh > opactest.log.$test 2>&1 & done

Since this is QAD, known limitations:
* Query can't handle phrase searches.
* Script does only GKEY keyword searches.
* Script uses term file based on the second the script started (e.g., start at 1:23:45 and the file is gkey_searchterms.45). Would be better if
this were random, avoiding re-use in any given set of runs.
