Bundler.require

require_relative "../db/host"

class MainApplication < Sinatra::Base

  set :slim, :pretty=>true
  set :views, File.expand_path('views/mainapplication')

  get '/' do
    @title= "La cocote"
    @groupsNo = Group.count
    @nInstances = Host.count
    @machines = Host.all(:limit=>5).reverse
    slim :index
  end

  get '/statuses/groups' do
    @groups = Group.all
    #(:hosts=>Host.all(:statuses=>(Status.all(:limit=>10).reverse)))
    slim :statusinstance
  end

  post %r{/([0-9A-Fa-f]{2}:[0-9A-Fa-f]{2}:[0-9A-Fa-f]{2}:[0-9A-Fa-f]{2}:[0-9A-Fa-f]{2}:[0-9A-Fa-f]{2})/(start|stop|reboot)} do |mac,action|
    g=Group.first_or_create(:name=>"default")
    
    g.hosts.first_or_create(:mac_address=>mac).
      statuses.create(:status=>action,:date=>Time.now,:runlevel=>params[:runlevel])
    status 201
  end

end
