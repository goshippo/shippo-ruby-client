require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './shippo.rb'
def parcel_list_result
  JSON::parse File.open('./parcel_list.json').read
end

module Shippo
  class ParcelTest < Test::Unit::TestCase
    def test_import
      ret = Shippo::Parcel.construct_from(parcel_list_result)
      assert_equal ret[:metadata], "Customer ID 123456"
      ret["metadata"] = "Customer ID 007"
      assert_equal ret.metadata, "Customer ID 007"
      assert_equal ret.object_owner, "tobias.schottdorf@gmail.com"
      ret[:object_owner] = "hans.wurst@gmail.com"
      assert_equal ret["object_owner"], "hans.wurst@gmail.com"
      assert_equal ret.object_state, "VALID"
      
    end
  end
end
