# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Xip::Services::Facebook::Version" do

  let(:version_in_file) { File.read(File.join(File.dirname(__FILE__), '..', 'VERSION')).strip }

  it "should return the current gem version" do
    expect(Xip::Services::Facebook::Version.version).to eq version_in_file
  end

  it "should return the current gem version via a constant" do
    expect(Xip::Services::Facebook::VERSION).to eq version_in_file
  end
end
