#! /usr/bin/env nix-shell
#! ruby # Hack for ruby parsing shebangs.
#! nix-shell -p inkscape -p ruby -i ruby

require "net/http"
require "pp"
require "json"
require "time"
require "fileutils"

puts "DO NOT RE-GENERATE. SORRY THE MANUALLY CUSTOMIZED NAME BARS ARE BETTER."
exit 1

TEMPLATE="name-bar.svg"
#SCHEDULE=URI("https://schedule.nixcon2017.org/en/nixcon2017/public/schedule.json")
#$schedule = JSON.parse(Net::HTTP.get(SCHEDULE))["schedule"]["conference"]
$schedule = JSON.parse(File.read("./schedule.json"))["schedule"]["conference"]
$days = $schedule["days"]

$participants = JSON.parse(File.read("./participants.json"))

$participants.each_with_index{|p, i|
	puts "#{i}, #{p["name"]}"
}
exit 1

TALK_PARTICIPANTS_MAPPING = {
 #12 => 24, #"public_name"=>"Bas van Dijk"},
 #16 => 22, #"public_name"=>"Sebastian Jordan"},
 #17 => 20, #"public_name"=>"Peter Simons"},
 #18 => 21, #"public_name"=>"Théophane Hufschmitt"},
 #22 =>  2, #"public_name"=>"Profpatsch"},
 #23 =>  4, #"public_name"=>"zimbatm"},
 #24 => 18, #"public_name"=>"Guillaume Maudoux (layus)"},
 #26 => 17, #"public_name"=>"Nicolas B. Pierron"},
 #27 => 23, #"public_name"=>"Thomas Strobel"},
 #30 =>  5, #"public_name"=>"fpletz"},
 #31 => 14, #"public_name"=>"Graham Christensen"},
 #32 =>  9, #"public_name"=>"Dan Peebles"},
 #34 =>  6, #"public_name"=>"Domen Kožar"},
 #35 => 10, #"public_name"=>"Eelco Dolstra"},
 #36 =>  8, #"public_name"=>"Robin Gloster"},
 #39 => 00, #"public_name"=>"Anton Latukha"}, # https://github.com/Anton-Latukha
}

$events = $days.map do |day|
	day["rooms"].values.flatten
end
	.flatten
	.reject do |event|
		event["title"] == "Breakfast" or
		event["title"] == "Lunch Break"
	end

$talk_persons = []

$talks_data = $events.map do |event|
	persons = event["persons"].map{|p|p["public_name"]}
	$talk_persons = $talk_persons.concat(event["persons"])
	duration = event["duration"].split(":").map(&:to_i)
	ends = Time.parse(event["start"])
	ends = ends + duration.first * 60 * 60 + duration.last * 60
	data = {
		title: event["title"],
		subtitle: event["subtitle"],
		date: event["date"],
		start: event["start"],
		ends: [ends.hour, ends.min].join(":"),
		duration: event["duration"],
		persons: persons,
		slug: event["slug"],
	}
	
	persons.each_with_index do |person, i|
		data[:"person#{i}"] = person
	end

	data
end

$files = []

$names = $talks_data.map { |talk| talk[:persons] }.flatten.sort.uniq

$talk_persons.sort!{|a,b| a["id"]<=>b["id"]}.uniq!

pp $talk_persons

raise "ok"

$names.each_with_index do |name, i|
	slug = name.gsub(/[^a-zA-Z_0-9]/, "_").downcase
	filename =  "name-bars/#{i.to_s.rjust(2, "0")}-#{slug}.svg"
	FileUtils.cp(TEMPLATE, filename)
	svg = File.read(filename)
	svg.gsub!(/%PERSON%/, name)
	File.write(filename, svg)
	puts "Wrote #{filename}"
	$files << filename
end

puts "... converting files to png ..."

$files.each do |file|
	print "#{file}..."
	`inkscape -e "#{file}.png" "#{file}"`
	puts " done"
end
