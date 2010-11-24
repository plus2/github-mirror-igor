module GithubMirror
  class MassagePayload
    def initialize(igor); @igor=igor end

    def call(env)
      payload = env['igor.payload']

      if repo = payload['repository']
        # XXX validate
        env['repository.owner'] = Hash === repo['owner'] ? repo['owner']['name'] : repo['owner']
        env['repository.name' ] = repo['name']

        @igor.call(env)
      else
        env['igor.errors'].puts "unrecognised payload: keys=#{env['igor.payload'].keys.inspect}"
        {:app => 'gh-mirror', :msg => "unrecognised payload"}
      end
    end
  end
end
