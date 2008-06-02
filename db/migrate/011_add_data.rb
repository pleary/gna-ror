class AddData < ActiveRecord::Migration
  def self.up
    _get_data do |table_data|
      table_data[1..-1].each { |row| table_data[0][:class].create(row)}
    end
  end

  def self.down
    tables = %w(
      access_rules
      access_types
      data_providers
      data_provider_roles
      data_sources
      organization_contacts
      organizations
      participant_contacts
      participants
      people
    )

    #SQL_DEP
    tables.each {|table| execute "delete from #{table}"}    

  end  

private
  def self._get_data 
    
    yield  [
      {:class => AccessType},
      {:name => "canResolveURI"},
      {:name => "canResolveURIPrivate"},
      {:name => "canResolveURIPublic"},
      {:name => "canCacheContent"},       
    ]
    
    yield  [
      {:class => DataSource},
      {
        :title => "Bees of GB",
        :description => "Name list of Great Britain Bees",
        :rights => "public domain",
        :citation => "Kehan Harman, Bees R Us, v.234, 221022-221089, 2008",
        :metadata_url => "http://nhm.org/bees/metadata",
        :endpoint_url => "MyString",
        :data_uri => "http://nhm.org/bees/data",
        :data_uri_type => "REST",
        :response_format => "XML",
        :refresh_period_hours => 10,
        :taxonomic_scope => "Insects",
        :geospation_scope_wkt => "",
        :in_gni => true,
        :created => "2008-06-01",
        :updated => "2008-06-01",
      },
      {
        :title => "Birds of GB",
        :description => "List of Great Britain Birds",
        :rights => "top secret",
        :citation => "John Harwards, Birders Journal v.33, p. 33-342, 2007",
        :metadata_url => "http://nhm.org/birds/metadata",
        :endpoint_url => "",
        :data_uri => "http://nhm.org/birds/data",
        :data_uri_type => "REST",
        :response_format => "XML",
        :refresh_period_hours => 120,
        :taxonomic_scope => "Aves",
        :geospation_scope_wkt => "",
        :in_gni => true,
        :created => "2008-06-01",
        :updated => "2008-06-01",
     }, 
    ]
    
    yield [
      {:class => Organization},
      {
        :name => "National History Museum, London",
        :identifier => "http://www.nhm.ac.uk",
        :acronym => "BM",
        :logo_url => "",
        :description => "NHM looks after old dead things",
        :address => "Cromwell Road, London, SW7 5BD",
        :decimal_latitude => 51.483334,
        :decimal_longitude => -0.450000,
        :related_information_url => "",
      },
      {
        :name => "Encyclopedia of Life",
        :identifier => "http://www.eol.org/",
        :acronym => "EOL",
        :logo_url => "",
        :description => "EOL serves species pages",
        :address => "7 MBL Street, Woods Hole, MA 02543",
        :decimal_latitude => 41.65002,
        :decimal_longitude => -70.56670,
        :related_information_url => "http://eol.org/about",
      }
    ]
    
    yield [
      {:class => Person},
      {
        :first_name => "John", 
        :last_name => "Doe",
        :job_title  => "System Administrator",
        :email => "jdoe@example.com",
        :telephone => "123 12345",
        :address => "23 Lindsey Rd, Stony Brook, NY, 12343"
      },
      {
        :first_name => "Jane", 
        :last_name => "Miller",
        :job_title  => "Programmer",
        :email => "jmiller@example.com",
        :telephone => "3232 5443 123242",
        :address => "332 Peters Lane, London, UK, 23423"        
      },
      {
        :first_name => "Sam", 
        :last_name => "Linn",
        :job_title  => "Scientist",
        :email => "slinn@example.com",
        :telephone => "3232 5443 123242",
        :address => "23 Long Avenue, Woods Hole, MA, 34323"        
      },
      {
        :first_name => "Yu", 
        :last_name => "Lee",
        :job_title  => "Data collector",
        :email => "ylee@example.com",
        :telephone => "334322323242",
        :address => "British Museum of Natural History, London, 2212"        
      },
    ]
    
    access_type_data = AccessType.find(:all, :order => :id)
    data_source_data = DataSource.find(:all, :order => :id)
    organization_data = Organization.find(:all, :order => :id)
    person_data = Person.find(:all, :order => :id)
    
    yield [
      {:class => AccessRule},
      {
        :data_source_id  => data_source_data[0].id,
        :access_type_id  => access_type_data[0].id,
        :is_allowed => true
      },
      {
        :data_source_id  => data_source_data[0].id,
        :access_type_id  => access_type_data[3].id, 
        :is_allowed => true
      },
    ]
    
    Participant.find(:all)
    
    yield [
      {:class => ParticipantPerson},
      {:person_id => person_data[0].id},
    ]
    
    yield [
          {:class => ParticipantOrganization},
          {:organization_id => organization_data[0].id},
        ]
    
    participant_data = Participant.find(:all, :order => :id)
    
    yield [
      {:class => DataProvider},
      {
        :data_source_id => data_source_data[0].id,
        :participant_id => participant_data[0].id,
      },
      {
        :data_source_id => data_source_data[0].id,
        :participant_id => participant_data[1].id,
      },
    ]
    
    data_provider_data = DataProvider.find(:all, :order => :id)
    
    yield [
      {:class => ParticipantContact},
      {
        :participant_id => participant_data[0].id,
        :person_id => person_data[0].id,
        :role => "technical host",
      },
      {
        :participant_id => participant_data[0].id,
        :person_id => person_data[1].id,
        :role => "data manager",
      },
    ]
    
    yield [
      {:class => OrganizationContact},
      {
        :organization_id => organization_data[0].id,
        :person_id => person_data[0].id,
      },
      {
        :organization_id => organization_data[0].id,
        :person_id => person_data[1].id,
      },
    ]
    
    yield [
      {:class => DataProviderRole},
      {
        :data_provider_id => data_provider_data[0].id,
        :role => "data manager",
      },
      {
        :data_provider_id => data_provider_data[1].id,
        :role => "technical host",
      },
    ]
  end

end