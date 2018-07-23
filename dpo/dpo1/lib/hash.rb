# Expanding of Ruby Hash Class
#  ({"a" => "A", "b" => "B", "c" => "C"}).deep_include?({ "c" => "C"})  #=> true
#  ({"a" => "A", "b" => "B", "c" => "C"}).deep_include?({ "c" => "c"})  #=> false
#  ({"a" => "A", "b" => "B", "c" => "C"}).deep_include?({ "x" => "X"})  #=> false
class Hash
  def deep_include?(sub_hash)
    sub_hash.keys.all? do |key|
      self.has_key?(key) && if sub_hash[key].is_a?(Hash)
        self[key].is_a?(Hash) && self[key].deep_include?(sub_hash[key])
      else
        self[key] == sub_hash[key]
      end
    end
  end
end