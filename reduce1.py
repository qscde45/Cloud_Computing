#!/usr/bin/env python

import sys

lastValue = None
currValue = None

for line in sys.stdin:
	key, value = line.strip().split('\t', 1)

	if lastValue == None:
		lastValue = key
		continue

	currValue = key

	print '%s\t%s' % (lastValue, currValue)

	lastValue = currValue