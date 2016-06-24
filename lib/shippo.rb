#
# +Shippo+ is the ruby module enclosing all and any ruby-based
# functionality developed by Shippo, Inc.
#
# This gem providers wrappers for Shippo API in ruby. You are
# not required to use any particular library to access Shippo
# API, but it is our hope that this gem helps you bootstrap your
# Shippo integration.
#

module Shippo
  class << self
    def require_all_from(folder)
      folder = "/#{folder}" unless folder.start_with? '/'
      ::Dir.glob(project_libs_folder + folder + '/*.rb') { |file| Kernel.require(file) }
    end

    private

    def project_libs_folder
      File.dirname(File.absolute_path(__FILE__))
    end

    def project_home
      project_libs_folder + '/..'
    end
  end
end


require 'shippo/api'
