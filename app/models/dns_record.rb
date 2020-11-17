class DnsRecord < ApplicationRecord
  has_many :dns_record_hostnames
  has_many :hostnames

  accepts_nested_attributes_for :hostnames
end
