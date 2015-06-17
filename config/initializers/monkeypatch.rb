class String
  def as_json(*options)
    return true if self == "true"
    return false if self == "false"
    self
  end
end
