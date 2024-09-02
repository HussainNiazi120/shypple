# frozen_string_literal: true

require_relative 'setup'

def get_port_input(prompt)
  loop do
    print prompt
    port = gets.chomp
    return port unless port.empty?

    puts "#{prompt.strip} cannot be empty"
  end
end

def handle_search_type(origin_port, destination_port)
  print 'Enter search type (cheapest-direct, cheapest, fastest): '
  search_type = gets.chomp

  case search_type
  when 'cheapest-direct'
    route = Search::CheapestDirectService.call(origin_port, destination_port)
  when 'cheapest'
    route = Search::CheapestService.call(origin_port, destination_port)
  when 'fastest'
    route = Search::FastestService.call(origin_port, destination_port)
  else
    puts 'Invalid search type'
    return
  end

  puts SerializeService.call(route).to_json
end

data = ShippingData::GetService.call
ShippingData::PopulateService.call(data)

loop do
  origin_port = get_port_input('Enter origin port: ')
  destination_port = get_port_input('Enter destination port: ')
  handle_search_type(origin_port, destination_port)

  print 'Do you want to perform another search? (yes/no): '
  break if gets.chomp.downcase != 'yes'
end
