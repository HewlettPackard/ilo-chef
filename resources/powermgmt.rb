actions :poweron, :poweroff, :resetsys, :resetilo

property :ilos, Array, :required => true

include ClientHelper

action :poweron do
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_power_state
    next if cur_val == "On"
    converge_by "Set ilo #{client.host} power ON" do
      client.set_power_state("On")
    end
  end
end

action :poweroff do
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_power_state
    next if cur_val == "Off"
    converge_by "Set ilo #{client.host} power ForceOff" do
      client.set_power_state("ForceOff")
    end
  end
end


action :resetsys do
  ilos.each do |ilo|
    client = build_client(ilo)
    converge_by "Set ilo #{client.host} power ForceRestart" do
      client.set_power_state("ForceRestart")
    end
  end
end

action :resetilo do
  ilos.each do |ilo|
    client = build_client(ilo)
    converge_by "Set ilo #{client.host} power Reset" do
      client.reset_ilo
    end
  end
end
