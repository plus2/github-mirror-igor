module GithubMirror
  class MassagePayload
    def initialize(igor); @igor=igor end

    def call(env)
      payload = env['igor.payload']

      if repo = payload['repository']
        env['repository.owner'] = repo['owner']['name']
        env['repository.name' ] = repo['name']
      elsif repo = payload['forced_repository']
        env['repository.owner'] = repo['owner']
        env['repository.name' ] = repo['name']
      end

      # XXX validate

      @igor.call(env)
    end
  end
end
