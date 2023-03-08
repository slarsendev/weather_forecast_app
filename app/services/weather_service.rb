class WeatherService < BaseService
    attr_reader :latitude, :longitude
    
    def initialize(latitude, longitude)
      @latitude = latitude
      @longitude = longitude
    end  
    
    def call
      conn = Faraday.new('https://api.openweathermap.org') do |f|
        f.request :json
        f.request :retry
        f.response :json
      end    
      
      response = conn.get('/data/2.5/weather', {
        appid: Rails.application.credentials.open_weather_api_key,
        lat: latitude,
        lon: longitude,
        units: 'metric',
      })
      
      body = response.body
      body or raise IOError.new 'Weather -> response body failed'
      body['main'] or raise IOError.new 'Weather -> main section is missing'
      body['main']['temp'] or raise IOError.new 'Weather -> temperature is missing'
      body['main']['temp_min'] or raise IOError.new 'Weather -> temperature minimum is missing'
      body['main']['temp_max'] or raise IOError.new 'OpenWeather -> temperature maximum is missing'
      body['weather'] or raise IOError.new 'Weather -> weather section is missing'
      body['weather'].length > 0 or raise IOError.new 'Weather -> weather section is empty'
      body['weather'][0]['description'] or raise IOError.new 'Weather -> weather description is missing'
      weather = OpenStruct.new
      weather.temperature = body['main']['temp']
      weather.temperature_min = body['main']['temp_min']
      weather.temperature_max = body['main']['temp_max']
      weather.humidity = body['main']['humidity']
      weather.pressure = body['main']['pressure']
      weather.description = body['weather'][0]['description']
      weather
    end
      
  end
  