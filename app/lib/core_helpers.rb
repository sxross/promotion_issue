class NSString
  def add_formatted(str, format = '%s')
    return self if str.nil?
    self << format % str if str.length > 0
    self
  end

  def to_us_phone
    phone = self.dup.gsub(/[^\d]/, '')
    last = phone[-4..-1]
    pre  = phone[-7..-5]
    area = phone[-10..-8]
    rest = phone[-(phone.length)..-11]

    String.new.add_formatted(rest, "+%s ").
               add_formatted(area, "(%s) ").
               add_formatted(pre, "%s-").
               add_formatted(last)
  end
end

class Fixnum
  def to_us_phone
    self.to_s.to_us_phone
  end

  def to_countable_s(thing, if_zero = 'no')
    number = self == 0 ? if_zero : self.to_s
    return number if self == 0
    thang = self == 1 ? thing : thing.pluralize
    "#{number} #{thang}"
  end
end

class Bignum
  def to_us_phone
    self.to_s.to_us_phone
  end

  def to_countable_s(thing, if_zero = 'no')
    number = self == 0 ? if_zero : self.to_s
    return number if self == 0
    thang = self == 1 ? thing : thing.pluralize
    "#{number} #{thang}"
  end
end

def development?
  RUBYMOTION_ENV == "development"
end

def release?
  !development?
end
