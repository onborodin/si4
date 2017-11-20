#!/usr/bin/env ruby

class Tail 

    def initialize(file)
        @file = file
    end

    def first
        f = File.open(@file,"r")
        f.seek(-100, :END)
        f.readline
        array = Array.new
        f.each do |line|
            array.push line
        end
        @pos = f.tell
        f.close
        array
    end

    def last
        f = File.open(@file, "r")
        f.seek(@pos)
        array = Array.new
        f.each do |line| 
            array.push line
        end
        @pos = f.tell
        f.close
        array
    end
    def pos
        @pos
    end
    def pos=(pos)
        @pos = pos
    end
end

t = Tail.new("/var/log/debug.log")
puts t.first
pos = t.pos

while true do
    t.pos = pos
    puts t.last
    pos = t.pos
    sleep 1
end

#EOF

