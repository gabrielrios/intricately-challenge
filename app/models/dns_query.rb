# Object for querying the DNS Database
class DnsQuery
  def self.filter(included = [], excluded = [])
    query = DnsRecord
      .from(
        # We need to create a temp table here because when filtering we want to check
        # the 'included' hostnames agains ALL of the DNS hostnames, if we used joins
        # it would return the record with ANY of the hostnames
        DnsRecord
          .select("dns_records.*, array_agg(hostnames.hostname)::text[] hostnames_array")
          .joins(:hostnames)
          .group("dns_records.id"),
        :dns_records)

    if included.present?
      query = query.where("hostnames_array @> ARRAY[?]", included)
    end

    if excluded.present?
      query = query.where.not("hostnames_array @> ARRAY[?]", excluded)
    end

    query
  end
end
