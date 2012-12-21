# encoding: utf-8
require 'spec_helper'

describe GeoDB::ZipCodeFinder do

  describe '.find_zip_codes' do
    subject { GeoDB::ZipCodeFinder.new.find_zip_codes(152597) }

    its(:size) { should == 9 }

    it { should include(10405) }
  end

end
