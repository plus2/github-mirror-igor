require 'angry_shell'
require 'pathname'

module GithubMirror
  class Mirror
    include AngryShell::ShellMethods

    def call(env)
      root = Pathname(env['mirrors']).expand_path
      payload = env['igor.payload']

      owner = payload['repository']['owner']['name']
      name  = payload['repository']['name']

      # XXX validate

      repo = root+owner+"#{name}.git"
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
