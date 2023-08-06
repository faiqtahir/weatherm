# frozen_string_literal: true

require 'date'

# This class provides methods to report weather data.
class WeatherReporter
  def self.display_extremes(_year, highest, lowest, humid)
    puts "Highest: #{highest[:temperature]}C on #{highest[:date].strftime('%B %d')}"
    puts "Lowest: #{lowest[:temperature]}C on #{lowest[:date].strftime('%B %d')}"
    puts "Humid: #{humid[:humidity]}% on #{humid[:date].strftime('%B %d')}"
  end

  def self.display_monthly_averages(_year_month, highest_avg, lowest_avg, humidity_avg)
    puts "Highest Average: #{highest_avg.round(1)}C"
    puts "Lowest Average: #{lowest_avg.round(1)}C"
    puts "Average Humidity: #{humidity_avg.round(1)}%"
  end

  def self.draw_temperature_chart(weather_data, month)
    matching_dates = weather_data.matching_dates(month)
    return if matching_dates.empty?

    month_name = Date::MONTHNAMES[month]
    year = matching_dates.keys.first.year
    puts "#{month_name} #{year}"

    matching_dates.each do |date, data|
      highest_temp = data[:temperature]
      lowest_temp = data[:temperature]
      puts_weather_data(date, highest_temp, lowest_temp)
    end
  end

  def self.puts_weather_data(date, highest_temp, lowest_temp)
    days_from_start = (date - date.at_beginning_of_month).to_i
    print '  ' * days_from_start
    print "#{date.day} "

    print_temperature_bar(highest_temp, "\e[41m")
    print " #{highest_temp}C - "
    print_temperature_bar(lowest_temp, "\e[44m")
    puts " #{lowest_temp}C"
  end

  def self.print_temperature_bar(temperature, color_code)
    print color_code
    temperature.times { print '+' }
    print "\e[0m"
  end
end
