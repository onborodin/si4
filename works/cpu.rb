#!/usr/bin/env ruby

require "sys/cpu"
include Sys

puts "VERSION: " + CPU::VERSION

puts "Load Average: " + CPU.load_avg.join(", ")
puts "CPU Freq (speed): " + CPU.freq.to_s unless RUBY_PLATFORM.match('darwin')
puts "Num CPU: " + CPU.num_cpu.to_s
puts "Architecture: " + CPU.architecture
puts "Machine: " + CPU.machine
puts "Model: " + CPU.model
