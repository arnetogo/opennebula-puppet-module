require 'rexml/document'
require 'erb'
require 'tempfile'

Puppet::Type.type(:onehost).provide(:onehost) do
  desc "onehost provider"

  commands :onehost => "onehost"

  def create
    output = "onehost create #{resource[:name]} --im #{resource[:im_mad]} --vm #{resource[:vm_mad]} --net #{resource[:vn_mad]} ", self.class.login
    `#{output}`
  end

  def destroy
    output = "onehost delete #{resource[:name]} ", self.class.login
    `#{output}`
  end

  def self.onehost_list
    output = "onehost list --xml ", login
    xml = REXML::Document.new(`#{output}`)
    onehosts = []
    xml.elements.each("HOST_POOL/HOST/NAME") do |element|
      onehosts << element.text
    end
    onehosts
  end

  def exists?
    if self.class.onehost_list().include?(resource[:name])
        self.debug "Found host: #{resource[:name]}"
        true
    end
  end

  def self.instances
    output = "onehost list -x ", login
    REXML::Document.new(`#{output}`).elements.collect("HOST_POOL/HOST") do |host|
      new(
        :name   => host.elements["NAME"].text,
        :ensure => :present,
        :im_mad => host.elements["IM_MAD"].text,
        :vm_mad => host.elements["VM_MAD"].text,
        :vn_mad => host.elements["VN_MAD"].text
      )
    end
  end

  # login credentials
  def self.login
    credentials = File.read('/var/lib/one/.one/one_auth').strip.split(':')
    user = credentials[0]
    password = credentials[1]
    login = " --user #{user} --password #{password}"
    login
  end

  # getters
  def im_mad
      result = ''
      output = "onehost show #{resource[:name]} --xml ", self.class.login
      xml = REXML::Document.new(`#{output}`)
      xml.elements.each("HOST/IM_MAD") { |element|
          result = element.text
      }
      result
  end

  def vm_mad
      result = ''
      output = "onehost show #{resource[:name]} --xml ", self.class.login
      xml = REXML::Document.new(`#{output}`)
      xml.elements.each("HOST/VM_MAD") { |element|
          result = element.text
      }
      result
  end

  def vn_mad
      result = ''
      output = "onehost show #{resource[:name]} --xml ", self.class.login
      xml = REXML::Document.new(`#{output}`)
      xml.elements.each("HOST/VN_MAD") { |element|
          result = element.text
      }
      result
  end

  # setters
  def im_mad=(value)
     raise "onehosts can not be updated. You have to remove and recreate the host"
  end

  def vm_mad=(value)
     raise "onehosts can not be updated. You have to remove and recreate the host"
  end

  def vn_mad=(value)
     raise "onehosts can not be updated. You have to remove and recreate the host"
  end

end
