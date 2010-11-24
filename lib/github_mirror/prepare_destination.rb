require 'pathname'

module GithubMirror
  class PrepareDestination
    def initialize(igor); @igor=igor end

    def call(env)
      begin
        env['mirror.root'] = Pathname(env['mirrors']).expand_path.tap {|root| root.mkpath}
        @igor.call(env)
      rescue
        env['igor.errors'].puts "problem prepareing mirror destination '#{env['mirrors']}': [#{$!.class}] #{$!}"
        $!.backtrace.each {|line| env['igor.errors'].puts line}

        {:app => 'gh-mirror', :msg => "unable to mirror: #{$!.class}: #{$!}"}
      end
    end
  end
end
