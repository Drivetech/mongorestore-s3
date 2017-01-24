#!/usr/bin/env python

import pymongo
import os
import sys

uri = os.environ['MONGO_URI']
data = pymongo.uri_parser.parse_uri(uri)

if len(sys.argv) == 2:
  print(data['database'])
else:
  auth = '' if data['username'] is None else '-u %s -p %s' % (data['username'], data['password'])
  host = '-h %s:%s' % (data['nodelist'][0][0], data['nodelist'][0][1])
  dbname = '-d %s' % data['database'] if os.environ.get('MONGO_COMPLETE') is None else ''
  extra = '' if os.environ.get('EXTRA') is None else os.environ.get('EXTRA')
  options = '%s %s %s %s' % (auth, host, dbname, extra)
  print(options)
