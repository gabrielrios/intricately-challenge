FactoryBot.define do
  factory :dns_record do
    ip { Array.new(4){rand(256)}.join('.') }

    hostnames do
      build_list :hostname, 2
    end
  end
end
