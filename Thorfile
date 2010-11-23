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

    Bunny.run do |b|
      ex = b.exchange(config.exchange, :type => :topic)
      repos.each do |repo|
        message = {
          'repository' => {
            'owner' => repo.owner,
            'name'  => repo.name
          }
        }

        key = "push.#{repo.owner}.#{repo.name}"

        puts "simulating push #{key}"

        ex.publish(Yajl::Encoder.encode(message), :key => key)
      end
    end
  end

  protected
  def bunny
    @bunny ||= Bunny.new.tap {|b| b.start} # XXX config
  end

  def config
    @config ||= AngryHash[ YAML.load_file( File.expand_path("../bind.yml", __FILE__) ) ]
  end
end

# vim: ft=ruby
