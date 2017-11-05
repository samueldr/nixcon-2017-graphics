#! /usr/bin/env nix-shell
#! ruby # Hack for ruby parsing shebangs.
#! nix-shell -p inkscape -p ruby -i ruby

require "net/http"
require "pp"
require "json"
require "time"
require "fileutils"

TEMPLATE="presentation.svg"
SCHEDULE=URI("https://schedule.nixcon2017.org/en/nixcon2017/public/schedule.json")
$schedule = JSON.parse(Net::HTTP.get(SCHEDULE))["schedule"]["conference"]
$days = $schedule["days"]

$events = $days.map do |day|
	day["rooms"].values.flatten
end
	.flatten
	.reject do |event|
		event["title"] == "Breakfast" or
		event["title"] == "Lunch Break"
	end

$talks_data = $events.map do |event|
	persons = event["persons"].map{|p|p["public_name"]}
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
		persons: persons.join(", "),
		slug: event["slug"],
	}
	
	persons.each_with_index do |person, i|
		data[:"person#{i}"] = person
	end

	data
end

$files = []

$talks_data.each_with_index do |talk, i|
	filename =  "presentation-cards/#{i.to_s.rjust(2, "0")}-#{talk[:slug]}.svg"
	FileUtils.cp(TEMPLATE, filename)
	svg = File.read(filename)
	talk.each do |key, value|
		svg.gsub!(/%#{key.to_s.upcase}%/, value)
	end
	svg.gsub!(/%[A-Z_]+[0-9]*%/, "")
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
