#!/usr/bin/env ruby

require 'digest/md5' 
require 'digest/sha1' 
require 'base64' 
require 'htauth'

class SiAuth

    def initialize(htpasswd)
        @htpasswd = htpasswd
    end

    def htpasswd
        @htpasswd
    end

    def auth?(user, password)
        File.open(@htpasswd).each do | line |
            htuser, digest = line.strip.split(':')
            next unless htuser == user
            if digest.match(/apr1/) then
                dummy, apr, salt = digest.split('$')
                md5 = HTAuth::Md5.new( 'salt' => salt )
                if md5.encode(password) == digest then
                    return true
                end
            elsif digest.match(/SHA/) then
                sha1 = HTAuth::Sha1.new
                if sha1.encode(password) == digest then
                    return true
                end
            end
        end
        return false
    end
end

s = SiAuth.new("./htpasswd")

user = "user1"
password = "qwerty"
puts "a" if s.auth?(user, password)

user = "user3"
password = "12345678"
puts "b" if s.auth?(user, password)

user = "user31"
password = "12345678"
puts "c" if s.auth?(user, password)


#EOF
