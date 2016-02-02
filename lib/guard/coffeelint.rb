require 'guard'
require 'guard/plugin'
require 'JSON'
require 'colorize'
# require 'coffeelint'

module Guard
  class Coffeelint < Plugin

    def initialize(options = {})
      super
      # @config_file = options[:config_file] || 'config/coffeelint.json'
      @config_file = options[:config_file]
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
      lint_and_report paths
      # Total errors across all files
      # error_count = 0

      # paths.each do |path|
      #   errors = lint_and_report(path)

      #   error_count += errors.length
      # end

      # notify(paths, error_count)

      # true
    end

    def run_all
      lint_and_report
    end

    protected

    def notify(file_count, error_count)
      message =  "#{error_count} errors in #{file_count} files"

      image = if error_count > 0
        :failed
      else
        :success
      end

      summary = "#{file_count} files scanned, "
      summary << if error_count > 0
                   "#{error_count} errors"
                 else
                   "No errors"
                 end
      summary << " found."

      Notifier.notify(summary, title: "Coffeelint", image: image)
    end


    def lint_and_report(paths = nil)
      # This is reporting some bad false-positives
      # errors = ::Coffeelint.lint_file(path, config_file: @config_file)

      # This works :|
      command = 'coffeelint -c --reporter raw'
      command += "-f #{@config_file}" if @config_file
      command += if paths && paths.length > 0
                   " #{paths.join ' '}"
                 else
                   ' .'
                 end

      puts command
      results = `#{command}`
      puts results
      puts $?.success?

      begin
        results = JSON.parse(results)
      rescue JSON::ParserError
        UI.error "Error linting #{paths}"
        return
      end

      results.each do |file, errors|
        errors.each do |error|
          error_letter = error['level'].chars.first.upcase
          error_letter = case error_letter
                         when 'E' then error_letter.red
                         when 'W' then error_letter.yellow
                         else error_letter
                         end

          puts "#{file.cyan}:#{error['lineNumber']}:#{error_letter}" \
            ": #{error['name']}: #{error['message']}.#{error['context']}"
        end
      end

      file_count = results.size
      error_count = results.map { |_, e| e.size }.reduce(:+)
      summary = "#{file_count} files scanned, "
      summary << if error_count > 0
                   "#{error_count} errors".red
                 else
                   "No errors".green
                 end
      summary << " found."

      puts "\n" + summary

      notify file_count, error_count

      throw :task_has_failed unless error_count == 0

      # errors = JSON.parse(`coffeelint --reporter raw -f #{@config_file} #{path}`).values.first

    #   if errors.length > 0
    #     UI.warning "Coffeelint: #{path} has #{errors.length} errors"

    #     errors.each do |error|
    #       UI.warning "#{error['lineNumber']}: #{error['message']} (#{error['context']})"
    #     end

    #   end

    #   errors
    end
  end
end
