[
  { ip: "1.1.1.1",
    hostnames: %w(lorem.com ipsum.com dolor.com amet.com) },
  { ip: "2.2.2.2",
    hostnames: %w(ipsum.com) },
  { ip: "3.3.3.3",
    hostnames: %w(ipsum.com dolor.com amet.com) },
  { ip: "4.4.4.4",
    hostnames: %w(ipsum.com dolor.com sit.com amet.com)},
  { ip: "5.5.5.5",
    hostnames: %w(dolor.com sit.com)}
].each do |attributes|
  hostnames = attributes[:hostnames].map do |hostname|
    { hostname: hostname }
  end

  next if DnsRecord.where(ip: attributes[:ip]).exists?
  DnsRecord.create(ip: attributes[:ip],
                   hostnames_attributes: hostnames)
end
