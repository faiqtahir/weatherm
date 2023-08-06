# frozen_string_literal: true

# This class provides methods to analyze weather data.
class WeatherAnalyzer
  def self.find_extremes(weather_data)
    highest_temp = weather_data.data.max_by { |_date, data| data[:temperature] }
    lowest_temp = weather_data.data.min_by { |_date, data| data[:temperature] }
    most_humid = weather_data.data.max_by { |_date, data| data[:humidity] }

    [highest_temp, lowest_temp, most_humid]
  end

  def self.calculate_monthly_averages(weather_data, month)
    matching_dates = weather_data.matching_dates(month)
    return nil if matching_dates.empty?

    num_days = matching_dates.size
    total_highest_temp = calculate_total_temperature(matching_dates)
    total_lowest_temp = calculate_total_low_temperature(matching_dates)
    total_humidity = calculate_total_humidity(matching_dates)

    average_highest_temp = total_highest_temp / num_days
    average_lowest_temp = total_lowest_temp / num_days
    average_humidity = total_humidity / num_days

    [average_highest_temp, average_lowest_temp, average_humidity]
  end

  private_class_method :calculate_total_temperature, :calculate_total_low_temperature, :calculate_total_humidity

  def self.calculate_total_temperature(matching_dates)
    matching_dates.values.sum { |data| data[:temperature] }
  end

  def self.calculate_total_low_temperature(matching_dates)
    matching_dates.values.sum { |data| data[:temperature_low] }
  end

  def self.calculate_total_humidity(matching_dates)
    matching_dates.values.sum { |data| data[:humidity] }
  end
end




