require 'spec_helper'

describe List do
  
  let(:json_file){ File.new(File.join(Rails.root, 'spec/support/films.json')) }
  let(:csv_file){ File.new(File.join(Rails.root, 'spec/support/films.csv')) }
  
  it "should create the movies list from json files" do
    @list = List.create!(:name => 'Asian Selection', :file => json_file)
    @list.films.size.should == 2
    @list.projections.size.should == 2
  end
  
  it "should create the movies list from json files" do
    @list = List.create!(:name => 'Asian Selection', :file => csv_file)
    @list.films.size.should == 2
    @list.projections.size.should == 0
  end
  
end
