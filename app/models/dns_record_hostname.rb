class DnsRecordHostname < ApplicationRecord
  belongs_to :hostname
  belongs_to :dns_record
end
