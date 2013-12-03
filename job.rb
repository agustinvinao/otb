class Job
  attr_reader :ancestor, :name
  def initialize(args={})
    @ancestor   = args[:ancestor]
    @name = args[:name]
  end

end