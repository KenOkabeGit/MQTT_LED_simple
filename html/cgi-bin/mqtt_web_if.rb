#!C:/tool/Ruby200/bin/ruby.exe
# -*- mode:ruby; coding:utf-8 -*-

require 'sqlite3'
require 'cgi'
require 'erb'


def save_status(status_led=[0,0,0])
  db = SQLite3::Database.new("iot.sqlite3")

  db.transaction do
    sql = "update led set status=? where id=?"
    db.execute(sql, status_led[0], 0)
    db.execute(sql, status_led[1], 1)
    db.execute(sql, status_led[2], 2)
  end

  db.close
end

def out_html(led)
  str_led = []
  (0..2).each do |i|
    str_led[i] = led[i]==1 ? "checked=\"checked\"" : ""
  end

  content = ""
  File.open("content_led.html.erb",'r:utf-8'){|f|
    content = ERB.new(f.read).result(binding)
  }

  print "Content-type: text/html\n\n"
  print content
end

cgi = CGI.new

status_led = [];
status_led[0] = cgi['led1']!='' ? 1 : 0
status_led[1] = cgi['led2']!='' ? 1 : 0
status_led[2] = cgi['led3']!='' ? 1 : 0


save_status(status_led)
# out_html(status_led)
