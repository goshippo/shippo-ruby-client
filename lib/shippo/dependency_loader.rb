module Shippo
  module DependencyLoader
    def project_libs_folder
      File.dirname(File.absolute_path(__FILE__)) + '/..'
    end

    def project_home
      project_libs_folder + '/..'
    end

    def require_all_from(folder)
      folder = "/#{folder}" unless folder.start_with? '/'
      ::Dir.glob(project_libs_folder + folder + '/*.rb') { |file| Kernel.require(file) }
    end
  end
end
