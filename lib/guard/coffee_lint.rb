
require 'guard'
require 'guard/plugin'

module Guard
  class CoffeeLint < Plugin

    VERSION = '0.0.1'

    def initialize(options = {})
      super()
    end

    # Default behaviour on file(s) changes that the Guard plugin watches.
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    # @return [Object] the task result
    #
    def run_on_change(paths)
      paths.each do |path|
        binding.pry
        ::Coffeelint.run_test_suite(path, :config_file => 'coffeelint_config.json')
      end
      true
    end

  end
end
