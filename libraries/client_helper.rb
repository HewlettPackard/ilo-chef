require_relative 'ilo_sdk'

module ClientHelper
  # Makes it easy to build a ILO_SDK::Client object
  # @param [Hash, ILO_SDK::Client] ilo Machine info or client object.
  # @return [ILO_SDK::Client] Client object
  def build_client(ilo)
    case ilo
    when ILO_SDK::Client
      return ilo
    when Hash
      log_level = ilo['log_level'] || ilo[:log_level] || Chef::Log.level
      return ILO_SDK::Client.new(ilo.merge(log_level: log_level))
    else
      raise "Invalid client #{ilo}. Must be a hash or ILO_SDK::Client"
    end
  end
end
