# open the CSV
require 'erb'
require 'csv'

shipments = []
CSV.foreach("planet_express_logs.csv", headers: true) do |row|
  shipments << row.to_hash
end


# perform all the calculations I need

# shipments => an array of records, where each record is a hash


fry_total = 0
fry_count = 0

bender_total = 0
bender_count = 0

leela_total = 0
leela_count = 0

amy_total = 0
amy_count = 0

shipments.each do |shipment|

  money = shipment["Money"].to_i

  case shipment["Destination"]
  when "Earth"
    fry_total += money
    fry_count += 1
  when "Mars"
    amy_total += money
    amy_count += 1
  when "Uranus"
    bender_total += money
    bender_count += 1
  else
    leela_total += money
    leela_count += 1
  end
end

total_revenue = shipments.map {|shipment| shipment["Money"].to_i}.reduce(:+)

revenue_by_planet = []
planets = shipments.map { |shipment| shipment["Destination"] }.uniq
planets.each do |planet|
  planet_revenue = shipments
                      .select { |shipment|  shipment["Destination"] == planet }
                      .map {|shipment| shipment["Money"].to_i }
                      .reduce(:+)
  revenue_by_planet << { "name" => planet, "total" => planet_revenue }
end


# generate the HTML

html_string = File.read("report.erb")
compiled_html = ERB.new(html_string).result(binding)
File.open("./index-output.html", "wb") {|file|
    file.write(compiled_html)
    file.close()
}
