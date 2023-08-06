# frozen_string_literal: true

require 'date'

# Class for analyzing and reporting weather data
class Weatherman
  class << self
    def main(args)
      case args[0]
      when '-e'
        analyze_extremes(args)
      when '-a'
        analyze_averages(args)
      when '-c'
        draw_temperature_chart(args)
      else
        display_help
      end
    end

    private

    def analyze_extremes(args)
      year = args[1].to_i
      folder_path = args[2]
      weather_data = load_weather_data(folder_path, "#{year}*.txt")

      highest, lowest, humid = WeatherAnalyzer.find_extremes(weather_data)
      WeatherReporter.display_extremes(year, highest, lowest, humid)
    end

    def analyze_averages(args)
      year_month = args[1]
      folder_path = args[2]
      _, month = year_month.split('/').map(&:to_i)
      weather_data = load_weather_data(folder_path, "#{year_month}*.txt")

      highest_avg, lowest_avg, humidity_avg = WeatherAnalyzer.calculate_monthly_averages(weather_data, month)

      if highest_avg.nil?
        puts "No data available for #{Date::MONTHNAMES[month]} #{year_month}."
      else
        WeatherReporter.display_monthly_averages(year_month, highest_avg, lowest_avg, humidity_avg)
      end
    end

    def draw_temperature_chart(args)
      year_month = args[1]
      folder_path = args[2]
      _, month = year_month.split('/').map(&:to_i)
      weather_data = load_weather_data(folder_path, "#{year_month}*.txt")

      WeatherReporter.draw_temperature_chart(weather_data, month)
    end

    def display_help
      puts 'Invalid option. Usage: ruby weatherman.rb [OPTION] ARGUMENT /path/to/filesFolder'
      puts 'Options:'
      puts '  -e YEAR           Display extremes for a given year'
      puts '  -a YEAR/MONTH     Display averages for a given month'
      puts '  -c YEAR/MONTH     Draw horizontal bar charts for a given month'
    end

    def load_weather_data(folder_path, pattern)
      weather_files = Dir.glob(File.join(folder_path, pattern))
      weather_data = WeatherData.new

      weather_files.each do |file|
        File.foreach(file) do |line|
          date, temperature, humidity = line.strip.split(',')
          weather_data.add_data(date, temperature, humidity)
        end
      end

      weather_data
    end
  end
end

if ARGV.length < 3
  puts 'Usage: ruby weatherman.rb [OPTION] ARGUMENT /path/to/filesFolder'
  puts 'For help, use: ruby weatherman.rb --help'
else
  Weatherman.main(ARGV)
end
