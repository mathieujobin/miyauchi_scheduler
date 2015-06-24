module Math
  def self.fact(n)
    if n == 0
      1
    else
      n * fact(n-1)
    end
  end

  def self.sum_up_to(n)
    (n+1).times.inject(0) {|t, x| t+=x}
  end
end
