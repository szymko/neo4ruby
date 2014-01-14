class BasicCommandUtilizer

  def initialize(commands, *args)
    @commands  = commands
  end

  def apply_commands(subject, *args)
    @commands.reduce(subject) { |r, c| r = c.perform(r, *args) }
  end

end