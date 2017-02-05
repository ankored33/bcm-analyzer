
class Array
  def count_to_hash
    k = Hash.new(0)
    self.each{|x| k[x] += 1 }
    return k
  end
end

arr = %w{ foo bar baz foo baz }
items = arr.count_to_hash
puts items