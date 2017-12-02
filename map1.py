#!/usr/bin/env python

import sys

string = ''

for line in sys.stdin:
	string = line.strip()
	for i in range(len(string)):
		key = string[i:]
		value = '0'
		print '%s\t%s' % (key, value)






