require 'spec_helper'

describe Gricer::BaseHelper do
  context 'format_percentage' do
    it 'should render a float as percentage' do
      format_percentage(0.4223432342352345).should == '42.23 %'
    end
  end
  
  context 'format_seconds' do
    it 'should render a time less than a minute' do
      format_seconds(42.42).should == '00:00:42'
    end
    
    it 'should render a time of full minutes' do
      format_seconds(2*60).should == '00:02:00'
    end

    it 'should render a time of full hours' do
      format_seconds(3*60*60).should == '03:00:00'
    end
    
    it 'should render a time combined of hours, minutes and seconds' do
      format_seconds(1*60*60 + 42*60 + 23).should == '01:42:23'
    end
  end
  
end
