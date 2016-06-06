# open the CSV
require 'erb'
require 'csv'

shipments = []
CSV.foreach("planet_express_logs.csv", headers: true) do |row|
  shipments << row.to_hash
end


# perform all the calculations I need

# shipments => an array of records, where each record is a hash
all_shipment_revenue = shipments.map do |shipment|
  shipment["Money"].to_i
end

fry_total = 0
fry_count = 0

bender_total = 0
bender_count = 0

leela_total = 0
leela_count = 0

amy_total = 0
amy_count = 0

shipments.each do |shipment|
  if shipment["Destination"] == "Earth"
    fry_total += shipment["Money"].to_i
    fry_count += 1
  elsif shipment["Destination"] == "Mars"
    amy_total += shipment["Money"].to_i
    amy_count += 1
  elsif shipment["Destination"] == "Uranus"
    bender_total += shipment["Money"].to_i
    bender_count += 1
  else
    leela_total += shipment["Money"].to_i
    leela_count += 1
  end
end


# all_shipment_review => an array of integers
total_revenue = all_shipment_revenue.reduce(:+)

puts "Total Revenue #{total_revenue}"

# generate the HTML

html_string = File.read("report.erb")
compiled_html = ERB.new(html_string).result(binding)
File.open("./index-output.html", "wb") {|file|
    file.write(compiled_html)
    file.close()
}
