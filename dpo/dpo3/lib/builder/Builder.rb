class Builder
  def build(iterator)
    str = ""
    while ( iterator.hasNext == true )
      str << iterator.next.getString
    end
    return str
  end
end