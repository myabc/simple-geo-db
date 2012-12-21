# encoding: utf-8
require 'spec_helper'

describe GeoDB::ProvinceFinder do
  describe '.all_provinces' do

    context 'in Germany' do
      subject { GeoDB::ProvinceFinder.all_provinces }

      its(:size) { should == 16 }

      it 'should return all Bundesländer' do
        subject.map(&:name).should == %w(
          Brandenburg
          Berlin
          Baden-Württemberg
          Bayern
          Bremen
          Hessen
          Hamburg
          Mecklenburg-Vorpommern
          Niedersachsen
          Nordrhein-Westfalen
          Rheinland-Pfalz
          Schleswig-Holstein
          Saarland
          Sachsen
          Sachsen-Anhalt
          Thüringen
        )
      end
    end

    # with no data loaded
    context 'in Switzerland' do
      subject { GeoDB::ProvinceFinder.new('ch').all_provinces }

      its(:size) { should == 0 }
    end

    context 'in Austria' do
      subject { GeoDB::ProvinceFinder.new('at').all_provinces }

      its(:size) { should == 0 }
    end

    context 'an unsupported country' do
      subject { GeoDB::ProvinceFinder.new('XX').all_provinces }

      it 'should raise an error' do
        expect { subject }.to raise_error(KeyError)
      end
    end

  end
end
