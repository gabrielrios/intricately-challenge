class DnsRecord < ApplicationRecord
  has_many :dns_record_hostnames, inverse_of: :dns_record
  has_many :hostnames, through: :dns_record_hostnames

  accepts_nested_attributes_for :hostnames

  validates :ip, :dns_record_hostnames, presence: true

  def hostnames_attributes=(hostnames_attributes)
    hostnames_attributes.each do |hostname_attributes|
      hostname = Hostname.where(hostname_attributes).first_or_initialize
      next if hostname.invalid?
      dns_record_hostnames.build(hostname: hostname)
    end
  end
end
