json.total_records @dns_records.count

json.records @dns_records do |record|
  json.id record.id
  json.ip_address record.ip
end

json.related_hostnames @hostnames do |hostname|
  json.hostname hostname.hostname
  json.count hostname.dns_record_count
end
