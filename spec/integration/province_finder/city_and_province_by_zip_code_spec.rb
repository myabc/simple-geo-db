# encoding: utf-8
require 'spec_helper'

describe GeoDB::ProvinceFinder do
  describe '.city_and_province_by_zip_code' do

    subject { GeoDB::ProvinceFinder.city_and_province_by_zip_code(zip_code) }

    context 'invalid Postleitzahl' do
      let(:zip_code) { 99999 }

      it { should be_nil }
    end

    context 'valid Postleitzahl (NRW-example)' do
      let(:zip_code) { 32657 }

      its(:size) { should be(2) }
      it 'should return correct city and province' do
        subject.map(&:name).should == %w(Lemgo Nordrhein-Westfalen)
      end
    end

    context 'valid Postleitzahl (Bayern-example)' do
      let(:zip_code) { 80331 }

      its(:size) { should be(2) }
      it 'should return correct city and province' do
        subject.map(&:name).should == %w(München Bayern)
      end
    end

  end
end
