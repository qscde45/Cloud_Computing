#!/usr/bin/env python

import sys

### Prevents pipe IO errors for large files.
from signal import signal, SIGPIPE, SIG_DFL
signal(SIGPIPE,SIG_DFL)
###

def lcp(sub1, sub2):
	length = len(sub1) if len(sub1) <= len(sub2) else len(sub2)
	for i in range(length):
		if (sub1[i] != sub2[i]):
			return i
	return length

#below are modified on 11.28

for line in sys.stdin:
	line = line.strip()
	sub1, sub2 = line.split('\t', 1)
	length = lcp(sub1, sub2)
	if length != 0:
		print '%s\t%s' % (length, sub1[0:length])



