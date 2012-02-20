require 'spec_helper'

describe "Gricer Agent Model" do
  for_all_databases do

    subject { Gricer.config.agent_model.new }

    it 'should get Agent info from parser' do
      Gricer::Parsers::Agent.should_receive(:get_info).with('My new TopBrowser/42.23 with TopEngine/123.45 on a TopOS') do 
        {
          name: 'Top Browser',
          full_version: '42.23',
          major_version: '42',
          engine_name: '23',
          engine_version: '123.45',
          os: 'TopOS',
          agent_class: :browser
        }
      end
    
      subject.request_header = 'My new TopBrowser/42.23 with TopEngine/123.45 on a TopOS'
      subject.calculate_agent_info  
      
      subject.name.should == 'Top Browser'
      subject.full_version.should == '42.23'
      subject.major_version.should == '42'
      subject.engine_name.should == '23'
      subject.engine_version.should == '123.45'
      subject.os.should == 'TopOS'
      subject.agent_class.should == :browser
    end
  end
end