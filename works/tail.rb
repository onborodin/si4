#!/usr/bin/env ruby

file = "/var/log/debug.log"
f = File.open(file,"r")

f.seek(-100, :END)
f.readline
f.each do |line|
    print line
end
current = f.tell
f.close


while true do
    f = File.open(file, "r")
    f.seek(current)
    f.each do | line | 
        print line
    end
    current = f.tell
    f.close
    sleep 1
end

#EOF

