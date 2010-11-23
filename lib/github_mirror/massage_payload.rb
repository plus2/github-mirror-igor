module GithubMirror
  class MassagePayload
    def initialize(igor); @igor=igor end

    def call(env)
      payload = env['igor.payload']

      if repo = payload['repository']
        # XXX validate
        env['repository.owner'] = Hash === repo['owner'] ? repo['owner']['name'] : repo['owner']
        env['repository.name' ] = repo['name']

      # XXX validate

      @igor.call(env)
    end
  end
end
