require 'bunny'

class Mirror < Thor
  desc "bind", "bind queues"
  def bind
    q = bunny.queue("git-mirror") # XXX config
    e = bunny.exchange('plus2.git', :type => 'topic')

    q.bind(e, :key => 'push.#')
  end

  desc "all", "mirror all repos"
  def all
  end

  protected
  def bunny
    @bunny ||= Bunny.new.tap {|b| b.start} # XXX config
  end
end

# vim: ft=ruby
