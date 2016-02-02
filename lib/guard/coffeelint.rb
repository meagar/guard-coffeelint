require 'guard'
require 'guard/plugin'
require 'JSON'
require 'colorize'

module Guard
  class Coffeelint < Plugin

    def initialize(options = {})
      super
      @config_file = options[:config_file]
    end

    def start
      UI.info "Guard::Coffeelint linting against #{@config_file}"
    end

    def run_on_additions(paths)
      lint_and_report paths
    end

    def run_on_modifications(paths)
      lint_and_report paths
    end
    
    def run_all
      lint_and_report
    end

    protected

    def notify(file_count, error_count)
      msg = summary file_count, error_count
      image = if error_count > 0
        :failed
      else
        :success
      end
      Notifier.notify(msg, title: "Coffeelint", image: image)
    end


    def lint_and_report(paths = nil)
      command = 'coffeelint -c --reporter raw'
      command += "-f #{@config_file}" if @config_file
      command += if paths && paths.length > 0
                   " #{paths.join ' '}"
                 else
                   ' .'
                 end

      results = `#{command} 2>&1`

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
      puts "\n" + summary(file_count, error_count, color: true)

      notify file_count, error_count

      throw :task_has_failed unless error_count == 0
    end

    def summary(file_count, error_count, color: false)
      summary = "#{file_count} files scanned, "
      summary << if error_count > 0
                   s = "#{error_count} errors"
                   color ? s.red : s
                 else
                   s = "No errors"
                   color ? s.green : s
                 end
      summary << " found."
    end
  end
end
