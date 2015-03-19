class User < ModelBase
  finalize!
  # has_many :cats

  def name
    "#{fname} #{lname}"
  end

end
