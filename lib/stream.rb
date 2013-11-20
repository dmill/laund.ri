module Stream
  def self.init
    @client = Restforce.new :username => ENV['SALESFORCE_USERNAME'],
    :password       => ENV['SALESFORCE_PSWD'],
    :security_token => ENV['SALESFORCE_SECURITY_TOKEN'],
    :client_id      => ENV['REST_API_CLIENT_ID'],
    :client_secret  => ENV['REST_API_CLIENT_SECRET']
    begin
      response = @client.authenticate!
      puts "Successfully authenticated to salesforce"
    rescue
      puts 'Could not authenticate'
    end
  end

  def self.create_stream(sfm_string)
   @client.create! 'PushTopic', {
      ApiVersion: '23.0',
      Name: sfm_string,
      Description: 'All ' + sfm_string,
      NotifyForOperations: 'All',
      NotifyForFields: 'All',
      Query: "select Id, Name from " + sfm_string
    } 
  end  

  def self.subscribe_to_stream(sfm_string)
    EM.run {
      @client.subscribe 'All' + sfm_string do |message|
        puts message.inspect
      end
    }
  end
end