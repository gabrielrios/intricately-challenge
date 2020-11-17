require 'rails_helper'

RSpec.describe 'DnsRecords Creation', type: :request do
  describe 'POST /dns_records' do
    let(:headers) do
      { 'CONTENT_TYPE' => 'application/json',
        'ACCETP' => 'application/json' }
    end

    it 'create dns record with associated hostnames' do
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

    it 'errors when creating a dns record without ip' do
      payload = {
        dns_records: {
          hostnames_attributes: [{ hostname: 'lorem.com' }]
        }
      }

      post dns_records_path, params: payload.to_json, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'errors when creating dns record without hostname' do
      payload = {
        dns_records: {
          ip: '1.1.1.1'
        }
      }

      post dns_records_path, params: payload.to_json, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'errors when create a dns record with a hostname with invalid data' do
      payload = {
        dns_records: {
          ip: '1.1.1.1',
          hostnames_attributes: [{ hostname: '' }]
        }
      }
      post dns_records_path, params: payload.to_json, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
