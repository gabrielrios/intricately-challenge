class CreateDnsRecordHostnames < ActiveRecord::Migration[6.0]
  def change
    create_table :dns_record_hostnames do |t|
      t.references :hostname, null: false, foreign_key: true
      t.references :dns_record, null: false, foreign_key: true

      t.timestamps
    end
  end
end
