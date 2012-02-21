require 'spec_helper'

describe Gricer::ActiveRecord::LimitStrings do
  subject { ActiveRecordStatModel.new }
  

  it 'should shorten to long stings' do
    subject.country = 'Deutschland'
    subject.save
    subject.country.should == 'De'
  end

end