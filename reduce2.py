#!/usr/bin/env python

import sys
maxLen = 0
lrs = ''

for line in sys.stdin:
	len, s = line.strip().split('\t')
	if len > maxLen:
		maxLen = len
		lrs = s

print '%s\t%s' % (maxLen, lrs)
