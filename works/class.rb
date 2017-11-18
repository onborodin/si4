#!/usr/bin/env ruby

class App
    @logfile = 'app.log'

    def self.logfile
        @logfile
    end

#    def logfile
#        @logfile
#    end
end

puts App.logfile
#puts App.new.logfile

#EOF

