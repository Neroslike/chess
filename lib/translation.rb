module Translation
  def translate(value)
    value.instance_of?(String) ? notation_to_array(value) : array_to_notation(value)
  end

  def notation_to_array(string)
    result = string.split('').reverse
    result[1] = result[1].ord - 97
    result[0] = result[0].to_i - 1
    result
  end

  def array_to_notation(array)
    result = array.reverse
    result[0] = (result[0] + 97).chr
    result[1] += 1
    result.join
  end
end
