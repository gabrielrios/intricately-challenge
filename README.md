# Intricately DNS Record API

API for storing DNS records (IP addresses) belonging to hostnames

## Setup

For setting this app for development you need to have Docker and docker-compose installed. After you had installed this
you can run 

    docker-compose up --build
    docker-compose run wep rails db:setup
    
This will start the application and load some seed data


## Test

To run the automated tests using the docker compose configuration you should follow the setup and then run

    docker-compose run web rspec


# Api Documentation

Currently we only have two endpoints one for inserting new DNS records, and another one for querying the records already created

## Insert new DNS Record [/dns_records] (POST)

You may create your own DNS records using this action. It takes a JSON object
containing a dns record with its hostnames and a collection of answers in the form of choices.

+ dns_record (object) - The DNS Record
  + ip (string) - The IP address of this record
  + hostname_attributes (array[object]) - Collection of hostnames for this Record
    + hostname (string) - Hostname

+ Request (application/json)

        curl --request POST \
        --url 'http://localhost:3000/dns_records' \
        --header 'content-type: application/json' \
        --data '{
            "dns_record": {
                "ip": "1.1.1.1",
                "hostnames_attributes": [
                    {
                        "hostname": "lorem.com"
                    }
                ]
            }
        }'
        
+ Response 201 (application/json)

    + Body
    
            { "id": 1 }
        

## Query DNS Records [/dns_records] (GET)

Query the DNS record database, you can filter the results based on the following query parameters

+ included (array(string)) - A list of all the hostnames the DNS records should have (optional parameter)
+ excluded (array[string]) - A list of hostnames the DNS records should not have (optional parameter)
+ page (integer) - A page number (required)

<br/>

+ Request (application/json)

        curl --request GET \
        --url 'http://localhost:3000/dns_records?page=1&included_hostnames[]=ipsum.com&included_hostnames[]=dolor.com&excluded_hostnames[]=sit.com' \
        --header 'content-type: application/json'
        
+ Response 200 (application/json)

    + Body
      
            {
                "total_records":2,
                "records": [
                    { 
                        "id": 3,
                        "ip_address":"1.1.1.1"
                    },
                    {
                        "id": 5,
                        "ip_address":"3.3.3.3"
                    }
                ],
                "related_hostnames": [
                    {
                        "hostname":"lorem.com",
                        "count":1
                    },
                    {
                        "hostname":"amet.com",
                        "count":2
                    }
                ]
            }

