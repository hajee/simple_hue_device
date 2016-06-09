require 'puppet/provider/hue'

Puppet::Type.type(:hue_light).provide(:rest, :parent => Puppet::Provider::Hue) do
  confine :feature => :posix
  defaultfor :feature => :posix

  mk_resource_methods

  def self.instances
    instances = []
    lights = Puppet::Provider::Hue.call('lights')

    return [] if lights.nil?

    lights.each do |light|
      instances << new(:name => light.first,
                       :on => light.last['state']['on'])
    end

    instances
  end

  def flush
    name = @original_values[:name]
    @property_hash = @property_hash.reject { |k, _v| !resource[k] }
    @property_hash.delete(:name)
    result = Puppet::Provider::Hue.put("lights/#{name}/state", @property_hash)
  end

  def create
    raise('Create not supported.')
  end

  def destroy
    notice('Destroy not supported.')
  end
end
