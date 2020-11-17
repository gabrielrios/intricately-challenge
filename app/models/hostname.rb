class Hostname < ApplicationRecord
  has_many :dns_record_hostnames
  validates :hostname, presence: true
end
