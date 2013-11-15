#!/usr/bin/env ruby
=begin

Skript för att kontrollera om IP Only har driftstörning på sitt nätverk.

Copyright (c) 2013 Jonas Björk <jonas.bjork@gmail.com>

This is free software; you can copy and distribute and modify this program under 
the terms of GNU General Public License ( http://www.gnu.org/copyleft/gpl.html )

Normalt meddelande för IP Only när de inte har störningar är:

<section class="main"><h1>Aktuell driftstatus</h1>
            <p>Current status:</p>
<p>No major disturbances to report.</p>
    	</section>

Detta blir en MD5 hash på: d2c1e2acfc797ee11977e2d2d38c0def
=end

begin
	require 'nokogiri'
	require 'mechanize'
	require 'digest/md5'
rescue LoadError
	puts "nokogiri, mechanize and digest/md5 is needed. Check your gem installation."
	exit 1
end


ipo_sum = "d2c1e2acfc797ee11977e2d2d38c0def"

agent = Mechanize.new
agent.user_agent_alias = 'Mac Safari'
page = agent.get('http://www.ip-only.se/aktuell-driftstatus/')
doc = Nokogiri::HTML(page.body)
bs = doc.xpath('//section[@class="main"]').to_s

digest = Digest::MD5.hexdigest( bs )

if digest.eql? ipo_sum then
	puts "No errors"
else
	puts "We have an error!"
end
