require 'angry_shell'

module GithubMirror
  class Mirror
    include AngryShell::ShellMethods

    def call(env)
      root    = env['mirror.root']

      owner = env['repository.owner']
      name  = env['repository.name']

      repo = root+owner+"#{name}.git"
      repo.parent.mkpath

      if repo.exist?
        sh("git fetch", :cwd => repo).run
      else
        url = "git@github.com:#{owner}/#{name}.git"
        sh("git clone --mirror #{url} #{repo}").run

      end

      nil
    end
  end
end
