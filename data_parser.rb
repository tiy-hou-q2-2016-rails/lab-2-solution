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
