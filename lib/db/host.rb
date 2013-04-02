DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite:///home/fvollero/tmp/status_active/db/database.sqlite3")

class Host
  include DataMapper::Resource

  property :mac_address, String, :key=>true
  
  belongs_to :group

  has n, :statuses
  

  def last_reboot
    unless self.statuses.last(:status=>:reboot)
      "%2.5f"%(self.statuses.last(:status=>:start).date - self.statuses.last(:status=>:stop).date).to_f
    else
      self.statuses.last(:status=>:reboot).date
    end
  end

  private

end

class Status
  include DataMapper::Resource
  
  property :id, Serial
  property :status, Enum[:start,:stop, :reboot]
  property :runlevel, String, :length=>2
  property :date, DateTime
  belongs_to :host
end


class Group
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String

  has n, :hosts
end

DataMapper::finalize
DataMapper.auto_upgrade!
#DataMapper.auto_migrate!
