# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_online_session',
  :secret => 'f0ea2f3f008f72217abdb8a7146e8723b67a68a0bf6564d0f690bab609c89f9685f6c2f3870e57d3961daced81d872829c235e69d4006e8e6d7bb4c2a47e51d5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
