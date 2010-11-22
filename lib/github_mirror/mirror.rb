require 'angry_shell'
require 'pathname'

module GithubMirror
  class Mirror
    include AngryShell::ShellMethods

    def initialize(root)
      @root = Pathname(root).expand_path
    end

    def call(env)
      payload = env['igor.payload']

      owner = payload['repository']['owner']['name']
      name  = payload['repository']['name']

      # XXX validate

      repo = @root+owner+"#{name}.git"
      repo.parent.mkpath

      if repo.exist?
        sh("git fetch", :cwd => repo).run
      else
        url = "git@github.com:#{owner}/#{name}.git"
        sh("git clone --bare #{url} #{repo}").run
      end
    end
  end
end
