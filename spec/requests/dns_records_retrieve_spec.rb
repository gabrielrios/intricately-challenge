require "rails_helper"

RSpec.describe "DnsRecords Retrieve", type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  it 'returns a list of all created records' do
    hostnames = create_list(:hostname, 2)
    dns_records = create_list(:dns_record, 2, hostnames: hostnames)

    get dns_records_path, headers: headers

    expect(response).to have_http_status(:success)

    parsed_body = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_body[:total_records]).to eq(dns_records.size)
  end

  context "with sample data" do
    before do
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
        DnsRecord.create(ip: attributes[:ip],
                         hostnames_attributes: hostnames)
      end
    end

    it "returns only records that include sit.com" do
      get dns_records_path(included: "sit.com"), headers: headers

      expect(response).to have_http_status(:success)

      parsed_body = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_body[:total_records]).to eq(2)

      expect(parsed_body[:related_hostnames].size).to eq(1)

      related_hostname = parsed_body[:related_hostnames].first

      expect(related_hostname[:count]).to eq(2)
    end

    it "retuns only records that excludes sit.com" do
      get dns_records_path(excluded: "sit.com"), headers: headers

      expect(response).to have_http_status(:success)

      parsed_body = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_body[:total_records]).to eq(3)

      expect(parsed_body[:related_hostnames].size).to eq(4)

      related_hostname = parsed_body[:related_hostnames].first

      expect(related_hostname[:count]).to eq(1)
    end

    it "returns only record that includes ipsum.com, dolor.com and excludes sit.com" do
      get dns_records_path(included: %w(ipsum.com dolor.com), excluded: "sit.com"), headers: headers

      expect(response).to have_http_status(:success)

      parsed_body = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_body[:total_records]).to eq(2)

      ips = parsed_body[:records].map(&:ip)
      expect(ips).to eq(["1.1.1.1", "3.3.3.3"])
    end
  end
end
