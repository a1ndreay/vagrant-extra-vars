require 'getoptlong'
require 'json'

module VagrantExtraVars
  class Store
    @pass_vars = nil

    class << self
      def pass_vars
        return @pass_vars if @pass_vars

        parsed = {}

        opts = GetoptLong.new(
          ['--pass-var', GetoptLong::OPTIONAL_ARGUMENT],        # Defined in VagrantExtraVars
          ['--no-provision', GetoptLong::NO_ARGUMENT],
          ['--provision-with', GetoptLong::REQUIRED_ARGUMENT],
          ['--no-destroy-on-error', GetoptLong::NO_ARGUMENT],
          ['--destroy-on-error', GetoptLong::NO_ARGUMENT],
          ['--no-parallel', GetoptLong::NO_ARGUMENT],
          ['--parallel', GetoptLong::NO_ARGUMENT],
          ['--provider', GetoptLong::REQUIRED_ARGUMENT],
          ['--no-install-provider', GetoptLong::NO_ARGUMENT],
          ['--install-provider', GetoptLong::NO_ARGUMENT],
          ['--no-color', GetoptLong::NO_ARGUMENT],
          ['--color', GetoptLong::NO_ARGUMENT],
          ['--machine-readable', GetoptLong::NO_ARGUMENT],
          ['-v', '--version', GetoptLong::NO_ARGUMENT],
          ['--debug', GetoptLong::NO_ARGUMENT],
          ['--timestamp', GetoptLong::NO_ARGUMENT],
          ['--debug-timestamp', GetoptLong::NO_ARGUMENT],
          ['--no-tty', GetoptLong::NO_ARGUMENT],
          ['-h', '--help', GetoptLong::NO_ARGUMENT],
          ['--provision', GetoptLong::NO_ARGUMENT],
          ['-f', '--force', GetoptLong::NO_ARGUMENT],
          ['-g', '--graceful', GetoptLong::NO_ARGUMENT],
        )

        pass_var_found = false

        opts.each do |opt, arg|
          case opt
          when '--pass-var'
            begin
              parsed = JSON.parse(arg).transform_values(&:to_s)
              ENV['VAGRANT_PASS_VARS'] = JSON.dump(parsed)
              pass_var_found = true
            rescue JSON::ParserError => e
              warn "[VagrantExtraVars] Failed to parse --pass-var JSON: #{e.message}"
            end
          end
        end

        unless pass_var_found && parsed.any?
          if ENV['VAGRANT_PASS_VARS']
            begin
              parsed = JSON.parse(ENV['VAGRANT_PASS_VARS']).transform_values(&:to_s)
            rescue JSON::ParserError => e
              warn "[VagrantExtraVars] Failed to parse ENV['VAGRANT_PASS_VARS']: #{e.message}"
            end
          end
        end

        @pass_vars = parsed.freeze
      end
    end
  end
end
