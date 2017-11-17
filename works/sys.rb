#!/usr/bin/env ruby


require 'sys/uname'
require 'rbconfig'
include Sys


puts "VERSION: " + Uname::VERSION
puts 'Nodename: ' + Uname.nodename
puts 'Sysname: ' + Uname.sysname
puts 'Version: ' + Uname.version
puts 'Release: ' + Uname.release
puts 'Machine: ' + Uname.machine



#EOF

