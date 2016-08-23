require 'hashie/dash'
require 'active_support/inflector'
require 'shippo/exceptions'
module Shippo
  module API
    # For enumerations with discrete possible set of values, +Category+ class
    # offers it's subclasses and users tremendous benefits.
    #
    # Categories should be always created via the Facåde
    # +Shippo::API::Category.for(name, value)+. Although it is possible to
    # directly instantiate subclasses, it is not recommended for performance reasons.
    #
    # == Example
    #
    # ```ruby
    # require 'shippo/api'
    # class My::Big::Module::Size < ::Shippo::API::Category::Base
    #   allowed_values :small, :medium, :large, :xlarge, :xxlarge
    # end
    # # ⤷ [:small, :medium, :large, :xlarge, :xxlarge]
    #
    # my_size = Shippo::API::Category.for('size', 'xlarge')
    # # ⤷ XLARGE
    # my_size.class.name
    # # ⤷ My::Big::Module::Size
    # ```

    module Category
      @categories = {}
      class << self
        attr_accessor :categories
      end

      class DuplicateValueError < ::Shippo::Exceptions::APIError;
      end

      def self.key(value)
        value.to_s.downcase.to_sym
      end

      def self.for(name, value)
        cat = self.categories[name.to_s.downcase.to_sym]
        cat ? cat[value.to_s.downcase.to_sym] : nil
      end
    end
  end
end

Dir[File.dirname(__FILE__) + '/category/*.rb'].each {|file| require file }
