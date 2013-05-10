require_relative '../../../lib/hdcore'

describe Hdcore::Request do

  describe '.call' do
    it 'initializes and sends GET request to API endpoint' do
      test_action = 'some.action'
      Hdcore::Request.stub(:query_string).and_return(params = {some: 'params'})
      Hdcore::Request.should_receive(:init)
      Hdcore::Request.should_receive(:get).with("/call/api_action/#{test_action}/format/json/", params)
      Hdcore::Request.call(test_action, {})
    end
  end


  describe '.query_string' do
    it 'returns parameters merged with generated api parameters' do
      Hdcore::Request.stub(:generate_api_params).and_return(api_params = {some: 'api_params'})
      actual = Hdcore::Request.send(:query_string, 'some.action', params = {some_other: 'params'})
      actual.should == params.merge(api_params)
    end
  end


  describe '.generate_api_params' do
    it 'returns hash with four valid param keys' do
      actual = Hdcore::Request.send(:generate_api_params, "", {})
      actual.keys.should == [:api_key, :api_unique, :api_timestamp, :api_hash]
    end

    it 'returns [:api_key] => public key' do
      Hdcore::Request.stub(:public_key).and_return(key = 'some_public_key')
      actual = Hdcore::Request.send(:generate_api_params, "", {})
      actual[:api_key].should == key
    end

    it 'returns [:api_unique] => generated uuid' do
      Hdcore::Request.stub(:generate_uuid).and_return(uuid = 'some_uuid')
      actual = Hdcore::Request.send(:generate_api_params, "", {})
      actual[:api_unique].should == uuid
    end

    it 'returns [:api_timestamp] => time of execution' do
      timestamp = Time.now.to_i
      actual = Hdcore::Request.send(:generate_api_params, "", {})
      actual[:api_timestamp].should == timestamp
    end

    it 'returns [:api_hash] => generated hash' do
      Hdcore::Request.stub(:generate_hash).and_return(hash = 'some_hash')
      actual = Hdcore::Request.send(:generate_api_params, "", {})
      actual[:api_hash].should == hash
    end


    it 'generated hash formed with the correct elements: [timestamp, uuid, pkey, action, json-ified params]' do
      Hdcore::Request.stub(:generate_uuid).and_return(uuid = 'some_uuid')
      Hdcore::Request.stub(:private_key).and_return(private_key = 'some_private_key')

      Hdcore::Request.should_receive(:generate_hash).with(Time.now.to_i,
                                                          uuid,
                                                          private_key,
                                                          action = 'some.action',
                                                          (params = {some: 'optional_params'}).to_json
                                                        )

      Hdcore::Request.send(:generate_api_params, action, params)
    end
  end


  describe '.generate_hash' do
    it 'uses the SHA256 algorithm, and joins parameters with colons' do
      args = %w[one two three 4 five seven 8]
      hash = (Digest::SHA2.new << args.join(':')).to_s
      Hdcore::Request.send(:generate_hash, args).should == hash
    end
  end

  describe '.generate_uuid' do
    it 'uses Version 4 UUID' do
      SecureRandom.should_receive(:uuid).and_return(uuid = 'some_uuid')
      Hdcore::Request.send(:generate_uuid).should == uuid
    end
  end
end
