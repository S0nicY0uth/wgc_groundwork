require 'prime'

class Primes
  def self.sum_to(limit = 100)
    Prime.each(limit).inject(&:+)
  end
end
