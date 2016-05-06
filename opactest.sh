#!/bin/sh

BASEURL="http://cattestnew.library.ucla.edu"
EXITURL="${BASEURL}/vwebv/exit.do"
SEARCHURL="${BASEURL}/vwebv/search"
SEARCHPARMS="&searchCode=GKEY^*&searchType=1&page.search.search.button=Search"

# Use "random" file of terms based on current second
SUFFIX=`date +%S`
TERMFILE=searchterms/gkey_searchterms.${SUFFIX}

# Call the initial URL to set session cookies
echo "Initializing..."
COOKIE_FILE=`basename $0`.cookies.$$
curl -s --cookie-jar ${COOKIE_FILE} ${SEARCHURL} > /dev/null

echo "Doing searches from ${TERMFILE}..." 
cat ${TERMFILE} | while read TERMS; do
  # Build search URL
  URL="${SEARCHURL}?searchArg=${TERMS}${SEARCHPARMS}"
  echo ${URL}
  START=$(date +%s.%N)
  # Run the search, using session cookies
  curl -s --cookie ${COOKIE_FILE} ${URL} > /dev/null
  END=$(date +%s.%N)
  # How long did search take, in seconds
  DIFF=$(echo "$END - $START" | bc)
  echo ${DIFF}
done

# End the session, using session cookies
curl -s --cookie ${COOKIE_FILE} ${EXITURL} > /dev/null
# Clean up
rm ${COOKIE_FILE}

