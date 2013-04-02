module Host

  extend self

  def hosts
    @hosts ||=[]
  end

  def find_for(key)
    @hosts.select {|f| f[key.to_sym] }
    self
  end

  def order_by(key)
    @host.sort_by{|h| h[key.to_sym]}
    self
  end
end
