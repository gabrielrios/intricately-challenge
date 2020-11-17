require 'rails_helper'

RSpec.describe 'DnsRecords', type: :request do
  describe 'POST /dns_records' do
    it 'create dns record with associated hostnames' do
      headers = { 'CONTENT_TYPE' => 'application/json',
                  'ACCETP' => 'application/json' }

      payload = {
        dns_records: {
          ip: '1.1.1.1',
          hostnames_attributes: [{ hostname: 'lorem.com' }]
        }
      }

      post dns_records_path, params: payload.to_json, headers: headers

      expect(response).to be_created

      dns_record = DnsRecord.last
      expect(dns_record.hostnames).to be_present
    end
  end
end
