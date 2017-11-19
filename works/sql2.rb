#!/usr/bin/env ruby

require 'sqlite3'

class DB
    def initialize(dbname)
        @dbname = dbname
    end

    def query(query)
        db = SQLite3::Database.open @dbname
        db.results_as_hash = true
        res = db.execute(query)
        db.close unless db.closed?
        res
    end
end

class Domain < DB


    def count
        res = self.query("select count(id) as count from domain")
        res.first['count']
    end

    def nextid
        return 1 if self.count == 0
        res = self.query("select id from domain order by id desc limit 1")
        res.first['id'] += 1
    end

    def list
        self.query("select * from domain order by id")
    end

    def name?(name)
        res = self.query("select * from domain where name = '#{name}' order by id limit 1")
        return true if res.count > 0
        false
    end

    def id?(id)
        res = self.query("select * from domain where id = '#{id}' limit 1")
        return true if res.count > 0
        false
    end

    def id(name)
        res = self.query("select id from domain where name = '#{name}' order by id limit 1")
        return nil if res.count == 0
        res.first['id']
    end

    def name(id)
        res = self.query("select name from domain where id = '#{id}' limit 1")
        return nil if res.count == 0
        res.first['name']
    end

    def add(name)
        return false if self.name?(name)
        id = self.nextid
        self.query("insert into domain (id, name) values (#{id}, '#{name}')")
        self.name?(name)
    end

    def delete(id)
        return true unless self.id?(id)
        self.query("delete from domain where id = '#{id}'")
        !self.id?(id)
    end

    def update(id, newname)
        return false unless self.id?(id)
        return false if self.name?(newname)
        self.query("update domain set name = '#{newname}' where id = '#{id}'")
        self.name?(newname)
    end
end

class User < DB

    def initialize(db)
        super(db)
        @domain = Domain.new(db)
    end

    def count
        res = self.query("select count(id) as count from user")
        res.first['count']
    end

    def nextid
        return 1 if self.count == 0
        res = self.query("select id from user order by id desc limit 1")
        res.first['id'] += 1
    end

    def list
        self.query("select u.id, u.name, u.domainid, d.name as domain, u.password 
                    from user u, domain d
                    where u.domainid = d.id 
                    order by d.name, u.name")
    end

    def name?(name, domainid)
        return false unless @domain.id?(domainid)
        res = self.query("select u.id from user u, domain d 
                            where u.name = '#{name}' and u.domainid = d.id limit 1")
        return true if res.count > 0
        false
    end

    def id?(userid)
        res = self.query("select id from user where id = '#{userid}' limit 1")
        return true if res.count > 0
        false
    end

    def add(name, domainid, password)
        return false if self.name?(name, domainid)
        return false unless @domain.id?(domainid)
        id = self.nextid
        self.query("insert into user(id, name, domainid, password) 
                        values (#{id}, '#{name}', #{domainid}, '#{password}')")
        self.name?(name, domainid)
    end

    def delete(userid)
        return true if not self.id?(userid)
        self.query("delete from user where id = #{userid}")
        !self.id?(userid)
    end

end

class Alias < DB

    def initialize(db)
        super(db)
        @domain = Domain.new(db)
    end

    def count
        res = self.query("select count(id) as count from alias")
        res.first['count']
    end

    def nextid
        return 1 if self.count == 0
        res = self.query("select id from alias order by id desc limit 1")
        res.first['id'] += 1
    end

    def list
        self.query("select a.id, a.name, a.domainid, d.name as domain, goto
                    from alias a, domain d
                    where a.domainid = d.id
                    order by d.name, a.name")
    end

    def name?(name, domainid)
        return false unless @domain.id?(domainid)
        res = self.query("select a.id from alias a, domain d 
                            where a.name = '#{name}' and a.domainid = d.id limit 1")
        return true if res.count > 0
        false
    end

    def id?(userid)
        res = self.query("select id from alias where id = '#{userid}' limit 1")
        return true if res.count > 0
        false
    end

    def add(name, domainid, goto)
        return false if self.name?(name, domainid)
        return false unless @domain.id?(domainid)
        id = self.nextid
        self.query("insert into add(id, name, domainid, goto) 
                        values (#{id}, '#{name}', #{domainid}, '#{goto}')")
        self.name?(name, domainid)
    end

    def delete(id)
        return true if not self.id?(id)
        self.query("delete from alias where id = #{id}")
        !self.id?(id)
    end

end

d = Domain.new('db')
u = User.new('db')
#puts u.list
#puts u.name?("aa", 1)

a = Alias.new('db')
a.list.each do | row |
    puts row
end
#EOF

