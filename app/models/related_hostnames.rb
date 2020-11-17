class RelatedHostnames
  def self.to(dns_records, included, excluded)
    new.to(dns_records, included, excluded)
  end
  def to(dns_records, included, excluded)
    base_query = if included.present?
                   Hostname.where(hostname: included)
                 else
                   Hostname.unscoped
                 end
    if excluded.present?
      excluded = Hostname.where.not(hostname: excluded)
    end

    base_query
      .joins(:dns_record_hostnames)
      .where(dns_record_hostnames: { dns_record_id: dns_records.map(&:id) })
      .select("DISTINCT hostnames.*, count(dns_record_id) as dns_record_count")
      .group("hostnames.id")
      .uniq
  end
end
