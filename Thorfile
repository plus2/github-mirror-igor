require 'bunny'
require 'angry_hash'
require 'yaml'
require 'tapp'
require 'net/https'
require 'open-uri'
require 'yajl'

class Mirror < Thor
  desc "bind", "bind queues"
  def bind
    q = bunny.queue("git-mirror") # XXX config
    e = bunny.exchange('plus2.git', :type => 'topic')

    q.bind(e, :key => 'push.#')
  end

  desc "all", "mirror all repos"
  def all
    gh = config.github

    orgs = gh.organizations

    repos = Yajl::Parser.parse( open("https://github.com/api/v2/json/organizations/repositories?login=#{gh.login}&token=#{gh.token}") )['repositories'].select {|repo|
      orgs.include? repo['organization']
    }.map {|repo| AngryHash[repo]}

    end
  end

  protected
  def bunny
    @bunny ||= Bunny.new.tap {|b| b.start} # XXX config
  end
end

# vim: ft=ruby
