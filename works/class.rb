#!/usr/bin/env ruby

#class App
#    @logfile = 'app.log'
#    def self.logfile
#        @logfile
#    end
##    def logfile
##        @logfile
##    end
#end

#puts App.logfile
#puts App.new.logfile

module Hi
    def hi
        "hi!"
    end
end

class Ho
    include Hi
end

class Ha
    extend Hi
end

class Ho2 < Ho
end

class Ha2 < Ha
end


puts Ho.new.hi
puts Ha.hi
puts Ho2.new.hi
puts Ha2.hi

#EOF

