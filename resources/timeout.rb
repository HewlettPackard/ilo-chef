actions :set

property :ilos, Array, :required => true
property :timeout, Fixnum, :equal_to => [15, 30, 60, 120, 0]

include ClientHelper

action :set do
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_timeout
    next if cur_val == timeout
    converge_by "Set ilo #{ilo} session timeout from '#{cur_val.to_s}' to '#{timeout.to_s}'" do
      client.set_timeout(timeout)
    end
  end
end
