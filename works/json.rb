#!/usr/bin/env ruby

require 'json'

config = Hash.new
begin 
    config = JSON.parse(File.open("si4.conf").read)
    puts config["logfile"]
rescue
end

#EOF

