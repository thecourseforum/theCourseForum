# Author: Lawrence Hook

# These were useful
# 	http://docs.aws.amazon.com/AWSECommerceService/latest/DG/ItemLookup.html
# 	http://docs.aws.amazon.com/AWSECommerceService/latest/DG/rest-signature.html
# 	http://docs.aws.amazon.com/AWSECommerceService/latest/DG/HMACAuth_ItemsRequired.html
# 	http://docs.aws.amazon.com/AWSECommerceService/latest/DG/AnatomyOfaRESTRequest.html

# URL encoding
require "erb"
include ERB::Util
# Calculate an RFC 2104-compliant HMAC with the SHA256 hash algorithm
require 'openssl'

ActiveRecord::Base.logger.level = 1

# log progress
log = File.open("#{Rails.root.to_s}/books/aws_#{Time.now.strftime("%Y.%m.%d-%H:%M")}.log", 'w')

# For testing
TEST_ISBN = Book.find(1).isbn

# Load up the secrets
config = {}
File.open("#{Rails.root.to_s}/books/aws_secret").each do |line|
	symbol, content = *line.split(';')
	config[symbol.to_sym] = content.chomp
end

# Order of parameters
ordered_keys = %w(AWSAccessKeyId AssociateTag Operation IdType ItemId SearchIndex Version Timestamp Signature)

# Beginnings of url for GET requests
url = 'http://webservices.amazon.com/onca/xml?'

# Parameters to be appended to url
params = {
	:Service => 'AWSECommerceService',
	:AWSAccessKeyId => config[:AWSAccessKeyId],
	:AssociateTag => config[:AssociateTag],
	:Operation => 'ItemLookup',
	:IdType => 'ISBN',
	:ItemId => TEST_ISBN,
	:SearchIndex => 'Books',
	:Version => '2013-08-01',
	:Timestamp => Time.now.utc.strftime('%FT%TZ')
}

# Required steps for signature
canonical_string = Hash[params.sort].map do |key, value|
	url_encode(key) + "=" + url_encode(value)
end.join("&")
to_sign = "GET\nwebservices.amazon.com\n/onca/xml\n" + canonical_string

# Copied from http://stackoverflow.com/questions/16599436/calculate-an-rfc-2104-compliant-hmac-with-the-sha256-hash-algorithm-in-ruby
sha256 = OpenSSL::Digest::SHA256.new
sig = OpenSSL::HMAC.digest(sha256, config[:secret], to_sign)
signature = url_encode(Base64.encode64(sig).chomp)

# Create properly formatted url
url = url + params.to_query + "&Signature=" + signature

RestClient.get(url) do |response, request, result|
	puts response
	puts request
	puts result
end
