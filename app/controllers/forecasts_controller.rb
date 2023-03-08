class ForecastsController < ApplicationController
    before_action :set_session, only: %i(show)
  
    def show
      if address
        begin
          @geocode = GeocodeService.call(address)
          @weather_cache_key = "#{@geocode.country_code}/#{@geocode.postal_code}"
          @weather_cache_exist = Rails.cache.exist?(@weather_cache_key)
          @weather = Rails.cache.fetch(@weather_cache_key, expires_in: 30.minutes) do
            WeatherService.call(@geocode.latitude, @geocode.longitude)          
          end
        rescue => e
          flash.alert = e.message
        end
      end
    end
  
    private
      def address
        @address ||= params[:address]
      end
  
      def set_session
        session[:address] = params[:address]
      end
  end
  