# frozen_string_literal: true

require 'date'

# The WeatherData class manages weather data for different dates, temperatures, and humidities.
class WeatherData
  attr_reader :data

  def initialize
    @data = {}
  end

  def add_data(date, temperature, humidity)
    date = Date.parse(date)
    temperature = temperature.to_f
    humidity = humidity.to_f

    @data[date] = { temperature: temperature, humidity: humidity }
  end

  def matching_dates(month)
    @data.select { |date, _| date.month == month }
  end
end
