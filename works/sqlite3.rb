#!/usr/bin/env ruby

require 'sqlite3'

class MailDB

    def initialize(dbname)
        @dbname = dbname
    end
    def dbname
        @dbname
    end

    def query(query = "select 1")
        db = SQLite3::Database.open @dbname
        db.results_as_hash = true
        res = db.execute(query)
        db.close unless db.closed?
        res
    end

    def domain_count
        res = self.query("select count(id) as count from domain")
        res.first['count']
    end

    def domain_nextid
        return 1 if self.domain_count == 0
        res = self.query("select id from domain order by id desc limit 1")
        res.first['id'] += 1
    end

    def domain_list
        self.query("select * from domain order by id")
    end

    def domain_name?(name)
        res = self.query("select * from domain where name = '#{name}' order by id limit 1")
        return true if res.count > 0
        false
    end

    def domain_id?(id)
        res = self.query("select * from domain where id = '#{id}' limit 1")
        return true if res.count > 0
        false
    end

    def domain_id(name)
        res = self.query("select id from domain where name = '#{name}' order by id limit 1")
        return nil if res.count == 0
        res.first['id']
    end

    def domain_name(id)
        res = self.query("select name from domain where id = '#{id}' limit 1")
        return nil if res.count == 0
        res.first['name']
    end

    def domain_add(name)
        return false if self.domain_name?(name)
        id = self.domain_nextid
        self.query("insert into domain values (#{id}, '#{name}')")
        self.domain_name?(name)
    end

    def domain_delete(id)
        return true unless self.domain_id?(id)
        res = self.query("delete from domain where id = '#{id}'")
        !self.domain_id?(id)
    end

    def domain_update(id, newname)
        return false unless self.domain_id?(id)
        return false if self.domain_name?(newname)
        self.query("update domain set name = '#{newname}' where id = '#{id}'")
        self.domain_name?(newname)
    end

    #### user ####

    def user_count
        res = self.query("select count(id) as count from user")
        res.first['count']
    end

    def user_nextid
        return 1 if self.user_count == 0
        res = self.query("select id from user order by id desc limit 1")
        res.first['id'] += 1
    end

    def user_list
        self.query("select * from user order by id")
    end

    def user_name?(name, domainid)
        return false unless self.domain_id?(domainid)
        res = self.query("select * from user u, domain d where u.name = '#{name}' and u.domainid = d.id limit 1")
        return true if res.count > 0
        false
    end

    def user_id?(userid)
        res = self.query("select * from user where id = '#{userid}' limit 1")
        return true if res.count > 0
        false
    end

    def user_add(name, domainid, password)
        return false if self.user_name?(name, domainid)
        return false unless self.domain_id?(domainid)
        userid = self.user_nextid
        self.query("insert into user values (#{userid}, '#{name}', #{domainid}, '#{password}')")
        self.user_name?(name, domainid)
    end

    def user_delete(userid)
        return true if not self.user_id?(userid)
        self.query("delete from user where id = #{userid}")
        !self.user_id?(userid)
    end
end

m = MailDB.new('db')
#puts d.exist?('unix7.org')
#puts d.exist?('unix8.org')
#puts d.list.to_s
#puts d.add('new1')
#puts d.rename('new1', 'new123')
#puts d.delete('new123')
#puts d.list.to_s

#puts m.user_list
puts m.user_add("abc", 2, "12345")
puts m.user_name?("abc", 1)
puts m.user_delete(1)
puts m.user_list

#EOF

