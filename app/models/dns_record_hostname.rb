class DnsRecordHostname < ApplicationRecord
  belongs_to :hostname, inverse_of: :dns_record_hostnames
  belongs_to :dns_record, inverse_of: :dns_record_hostnames
end
