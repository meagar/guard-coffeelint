
require 'guard'
require 'guard/plugin'
require 'coffeelint'

module Guard
  class Coffeelint < Plugin

    VERSION = '0.0.2'

    def initialize(options = {})
      super
      @config_file = options[:config_file] || 'config/coffeelint.json'
    end

    def start
      UI.info "Guard::Coffeelint linting against #{@config_file}"
    end

    # Default behaviour on file(s) changes that the Guard plugin watches.
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    # @return [Object] the task result
    #
    def run_on_changes(paths)
      # Total errors across all files
      error_count = 0

      paths.each do |path|
        errors = lint_and_report(path)

        error_count += errors.length
      end

      notify(paths, error_count)

      true
    end

    protected

    def notify(paths, error_count)
      message = if paths.length == 1
        "#{error_count} errors in #{paths[0]}"
      else
        "#{error_count} errors in #{paths.length} files"
      end

      Notifier.notify(message, title: "Coffeelint", image: :failed)
    end


    def lint_and_report(path)
      errors = ::Coffeelint.lint_file(path, config_file: @config_file)

      if errors.length > 0
        UI.warning "Coffeelint: #{path} has #{errors.length} errors"

        errors.each do |error|
          UI.warning "#{error['lineNumber']}: #{error['message']} (#{error['context']})"
        end

      end

      errors
    end

  end
end
