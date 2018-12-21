['./project.rb', 'sinatra/base', 'sinatra/json', 'json', 'fileutils', 'mysql2'].each {|mod| require mod}

# Some global constants and configs we choose to define, create database

class Webkit
  if ENV['RACK_ENV'] == 'production'
    @@config = {:name => 'piwitch', :production => true, :file => '/etc/sipwitchqt.conf'}
  else
    @@config = {:name => 'sipwitch', :port => '3306', :username => ENV['USER'], :password => nil, :production => false, :file => '../devtest.conf'}
  end

  File.open(@@config[:file], 'r') do |infile; section, line, key, value|
    section = nil
    while(line = infile.gets)
      line.gsub!(/(^|\s)[#].*$/, '')
      case line.strip!
      when /^\[.*\]$/
        section = line[1..-2].downcase
      when /[=]/
        key, value = line.split(/\=/).each {|s| s.strip!}
        key.downcase!
        case section
        when nil
          case key
          when 'realm'
            @@config[:realm] = value
          end
        when 'database'
          @@config[key.to_sym] = value
        end
      end
    end
  end if File.exists?(@@config[:file])
  @@config[:database] = @@config[:name]

  begin
    @@database = Mysql2::Client.new(@@config)
  rescue Mysql2::Error => e
    abort("*** ipl-sipwitch: mysql error=#{e.errno},#{e.error}")
  end
  
  def self.config
    return @@config
  end

  def self.realm
    return @@config[:realm]
  end

  def self.production?
    return @@config[:production]
  end

  def self.db
    return @@database
  end
end

