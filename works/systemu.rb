#!/usr/bin/env ruby

require 'systemu'

date = %q( ruby -e"  t = Time.now; STDOUT.puts t; STDERR.puts t  " )

status, stdout, stderr = systemu date
p [ status, stdout, stderr ]
#EOF

