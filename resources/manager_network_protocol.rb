actions :set
default_action :set

property :ilos, Array, required: true
property :timeout, Fixnum, equal_to: [15, 30, 60, 120, 0]

action_class do
  include IloHelper
end

action :set do
  load_sdk
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_timeout
    next if cur_val == timeout
    converge_by "Set ilo #{client.host} session timeout from '#{cur_val}' to '#{timeout}'" do
      client.set_timeout(timeout)
    end
  end
end
