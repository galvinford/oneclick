# Check that we got loaded from application.yml

raise "Config not loaded from application.yml" unless ENV['ENV_FROM_APPLICATION_YML']

# use as Rails.application.config.brand
Oneclick::Application.config.brand = ENV['BRAND'] || 'arc'

case ENV['BRAND'] || 'arc'
when 'arc'
  Oneclick::Application.config.geocoder_components = 'administrative_area:GA|country:US'
  Oneclick::Application.config.geocoder_bounds = [[33.737147,-84.406634], [33.764125,-84.370361]]
when 'broward'  
  Oneclick::Application.config.geocoder_components = 'administrative_area:FL|country:US'
  Oneclick::Application.config.geocoder_bounds = [[26.427309, -80.347081], [25.602294, -80.061728]]
when 'yata'  
  Oneclick::Application.config.geocoder_components = 'administrative_area:PA|country:US'
  Oneclick::Application.config.geocoder_bounds = [[41.970622, -80.461542], [39.734653, -75.007294]]
end

# General UI configuration settings
Oneclick::Application.config.ui_typeahead_delay = 300       # milliseconds delay between keystrokes before a query is sent to the server to retrieve a typeahead list
Oneclick::Application.config.ui_typeahead_min_chars = 4     # minimum number of characters to initiate a query
Oneclick::Application.config.ui_typeahead_list_length = 10  # max number of items displayed in the typeahead list  
Oneclick::Application.config.ui_search_poi_items = 10       # max number of matching POIs to return in a search 
Oneclick::Application.config.ui_min_geocode_chars = 5       # Minimum number of characters (not including whitespace) before sending to the geocoder 

Oneclick::Application.config.address_cache_expire_seconds = 3600 # seconds to keep addresses returned from the geocoder in the cache

