AWS_ACCESS_KEY_ID=''
AWS_SECRET_ACCESS_KEY=''

#SimpleRecord::Base.set_domain_prefix("ayopa-")

SimpleRecord.establish_connection(AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY, :connection_mode=>:per_thread)