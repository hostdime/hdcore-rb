require_relative '../../../lib/hdcore'

describe Hdcore do

  describe '.config' do
    it 'returns hash with expected keys [:api_endpoint, :public_key, :private_key]' do
      Hdcore.config.keys.should == [:api_endpoint, :public_key, :private_key]
    end

    it 'returns default [:api_endpoint] => "https://core.hostdime.com/api/v1"' do
      Hdcore.config[:api_endpoint].should == 'https://core.hostdime.com/api/v1'
    end

    it 'returns default [:public_key] => nil' do
      Hdcore.config[:public_key].should == nil
    end

    it 'returns default [:private_key] => nil' do
      Hdcore.config[:private_key].should == nil
    end
  end

  describe '.configure' do
    it 'assigns value if the key is valid' do
      # public_key is known to be a valid config key
      Hdcore.configure(public_key: 'some_value')
      Hdcore.config[:public_key].should == 'some_value'
    end

    it 'does nothing for invalid keys' do
      Hdcore.configure(bogus_key: 'some_value')
      Hdcore.config[:bogus_key].should be_nil
    end

    after do
      # reset to expected nil values
      Hdcore.configure({
              public_key:   nil,
              private_key:  nil
            })
    end
  end

  describe '.missing_config_values?' do
    it 'returns true by default, due to uninitialized config values' do
      Hdcore.missing_config_values?.should be_true
    end

    it 'returns true when a config value is nil' do
      Hdcore.stub(:config).and_return(some: nil)
      Hdcore.missing_config_values?.should be_true
    end

    it 'returns false when config values are not nil' do
      Hdcore.stub(:config).and_return(some: 'not_nil')
      Hdcore.missing_config_values?.should be_false
    end
  end

  describe '.missing_config_values' do
    it 'returns default [:public_key, :private_key]' do
      Hdcore.missing_config_values.should == [:public_key, :private_key]
    end

    it 'returns keys that have nil values' do
      Hdcore.stub(:config).and_return(empty_config_key: nil, not_empty: 'value')
      Hdcore.missing_config_values.should == [:empty_config_key]
    end
  end

end
