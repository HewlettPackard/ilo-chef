actions :set

property :ilos, Array, :required => true
property :timeout, Fixnum

include ClientHelper

action :set do
  raise "Error: Timeout must be 15, 30, 60, 120 or 0 (Infinite)" if not [15, 30, 60, 120, 0].include? timeout
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_timeout
    next if cur_val == timeout
    converge_by "Set ilo #{ilo} session timeout from '#{cur_val.to_s}' to '#{timeout.to_s}'" do
      client.set_timeout(timeout)
    end
  end
end
