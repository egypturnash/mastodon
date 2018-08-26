class FixReblogsInFeeds < ActiveRecord::Migration[5.1]
  def up
    # up method deleted because it won't talk to redis on my instance for some reason
    # and this one is just a speedup for Really Big Instances
  end

  def down
    # We *deliberately* do nothing here. This means that reverting
    # this and the associated changes to the FeedManager code could
    # allow one superfluous reblog of any given status, but in the case
    # where things have gone wrong and a revert is necessary, this
    # appears preferable to requiring a database hit for every status
    # in every users' feed simply to revert.

    # Note that this is operating under the assumption that entries
    # with >53-bit IDs have already been entered. Otherwise, we could
    # just use the data in Redis to reverse this transition.
  end
end
