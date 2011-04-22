# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Ayopa_session',
  :secret      => '34abdcbd20496ffba1a2f5c54363bc66321798f46bd71f52d440eb508e545d49a3f2d9481cca66ee993223771507897f4786b761144263170f4f5f1eafb275db'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
