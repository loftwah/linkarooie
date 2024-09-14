Geocoder.configure(
  # Geocoding options
  timeout: 5,                      # geocoding service timeout (secs)
  lookup: :google,                 # name of geocoding service (symbol)
  ip_lookup: :ipinfo_io,           # name of IP address geocoding service (you can choose a service)
  language: :en,                   # ISO-639 language code

  # Use HTTPS for lookup requests
  use_https: true,

  # API key for geocoding service
  api_key: ENV['GEOCODER_API_KEY'], # Geocoder API key from environment variable

  # Caching
  cache: Redis.new,                # cache object (e.g. Redis.new)
  cache_prefix: "geocoder:",       # prefix for cache keys

  # Exceptions that should not be rescued by default
  # (if you want to handle them yourself)
  always_raise: [
    Geocoder::OverQueryLimitError,
    Geocoder::RequestDenied,
    Geocoder::InvalidRequest,
    Geocoder::InvalidApiKey
  ],

  # Calculation options
  units: :km,                      # :km for kilometers or :mi for miles
  distances: :linear               # :spherical or :linear
)
