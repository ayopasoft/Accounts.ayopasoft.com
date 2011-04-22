AWS_ACCESS_KEY_ID='0R6CCZTH7V6XYXZBJ402'
AWS_SECRET_ACCESS_KEY='tujS3O39dEOe8PjpQlNuPgLHROKu7YnC1n7uw6z5'

SimpleRecord::Base.set_domain_prefix("ayopa-")

SimpleRecord.establish_connection(AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY, :connection_mode=>:per_thread)