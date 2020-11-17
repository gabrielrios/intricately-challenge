# Query the hostnames related to a group of DNS records
class RelatedHostnames
  def self.to(dns_records, included, excluded)
    new.to(dns_records, included, excluded)
  end

  def to(dns_records, included, excluded)
    Hostname.where.not(hostname: Array(included) + Array(excluded))
      .joins(:dns_record_hostnames)
      .where(dns_record_hostnames: { dns_record_id: dns_records.map(&:id) })
      .select("DISTINCT hostnames.*, count(dns_record_id) as dns_record_count")
      .group("hostnames.id")
      .uniq
  end
end
