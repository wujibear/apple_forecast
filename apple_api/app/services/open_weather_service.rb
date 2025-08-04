class OpenWeatherService
  def initialize
    @api_key = Rails.application.credentials.open_weather.api_key
    @client = OpenWeather::Client.new(api_key: @api_key)
  end
  
  def get_weather_by_address(address)
    # First, geocode the address to get coordinates
    coordinates = geocode_address(address)
    return { error: 'Address not found' } unless coordinates
    
    # Then get weather for those coordinates
    get_weather_by_coordinates(coordinates[:lat], coordinates[:lon])
  end
  
  private
  
  def geocode_address(address)
    # Use the OpenWeather geocoding API
    response = @client.geocode(q: address, limit: 1)
    
    return nil if response.empty?
    
    location = response.first
    {
      lat: location.lat,
      lon: location.lon,
      name: location.name,
      country: location.country
    }
  rescue => e
    Rails.logger.error "Geocoding error: #{e.message}"
    nil
  end
  
  def get_weather_by_coordinates(lat, lon)
    # Use the OpenWeather current weather API
    weather = @client.current_weather(lat: lat, lon: lon, units: 'metric')
    
    {
      location: weather.name,
      country: weather.sys.country,
      temperature: weather.main.temp,
      feels_like: weather.main.feels_like,
      humidity: weather.main.humidity,
      description: weather.weather.first.description,
      icon: weather.weather.first.icon,
      wind_speed: weather.wind.speed,
      pressure: weather.main.pressure
    }
  rescue => e
    Rails.logger.error "Weather API error: #{e.message}"
    { error: 'Weather data unavailable' }
  end
end
