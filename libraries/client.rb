require 'logger'
require_relative 'rest'
# Load all helpers:
Dir[File.join(File.dirname(__FILE__), '*_helper.rb')].each { |file| require file }

module ILO_SDK
  class Client
    attr_accessor :host, :user, :password, :ssl_enabled, :logger, :log_level

    # Create a client object
    # @param [Hash] options the options to configure the client
    # @option options [String] :host URL of OneView appliance
    # @option options [String] :user ('Administrator') Username to use for authentication with OneView appliance
    # @option options [String] :password Password to use for authentication with OneView appliance
    # @option options [Logger] :logger (Logger.new(STDOUT)) Logger object to use.
    #   Must implement debug(String), info(String), warn(String), error(String), & level=
    # @option options [Symbol] :log_level (:info) Log level. Logger must define a constant with this name. ie Logger::INFO
    # @option options [Boolean] :ssl_enabled (true) Use ssl for requests?
    def initialize(options = {})
      options = Hash[options.map { |k, v| [k.to_sym, v] }] # Convert string hash keys to symbols
      @logger = options[:logger] || Logger.new(STDOUT)
      [:debug, :info, :warn, :error, :level=].each { |m| fail "Logger must respond to #{m} method " unless @logger.respond_to?(m) }
      @log_level = options[:log_level] || :info
      @logger.level = @logger.class.const_get(@log_level.upcase) rescue @log_level
      @host = options[:host]
      fail 'Must set the host option' unless @host
      @ssl_enabled = options[:ssl_enabled].nil? ? true : options[:ssl_enabled]
      fail 'ssl_enabled option must be either true or false' unless [true, false].include?(@ssl_enabled)
      @logger.warn 'User option not set. Using default (Administrator)' unless options[:user]
      @user = options[:user] || 'Administrator'
      @password = options[:password]
      fail 'Must set the password option' unless @password
    end

    include Rest

    # Include helper modules:
    include Indicator_LED_Helper
    include Timeout_Helper
    include Time_Zone_Helper
    include Asset_Tag_Helper
    include Boot_Order_Helper
    include Computer_Details_Helper
    include Power_Metrics_Helper
    include Thermal_Metrics_Helper
    include SNMP_Helper
    include Powermgmt_Helper
    include User_Helper
    include Schema_Helper
    include Registry_Helper
    include Logs_Helper
    include UEFI_Helper
    include Bios_Helper
    include FW_Up_Helper
    include Virtual_Media_Helper
  end
end
