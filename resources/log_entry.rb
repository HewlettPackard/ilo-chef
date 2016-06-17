actions :clear, :dump
default_action :dump

property :ilos, Array, required: true
property :log_type, String, required: true, equal_to: ['IEL', 'IML']
property :severity_level, String, equal_to: ['OK', 'Warning', 'Critical']
property :dump_file, String
property :owner, [String, Integer]#, default: node['current_user']
property :group, [String, Integer]#, default: node['current_user']
property :duration, Integer, default: 24

action_class do
  include IloHelper
end

action :clear do
  load_sdk
  ilos.each do |ilo|
    client = build_client(ilo)
    next if client.logs_empty?(log_type)
    converge_by "Clear ilo #{client.host} #{log_type} logs" do
      client.clear_logs(log_type)
    end
  end
end

action :dump do
  load_sdk
  dump_content = {}
  ilos.each do |ilo|
    client = build_client(ilo)
    host = ilo[:host] || ilo['host']
    dump_content[host.to_s] = client.get_logs(severity_level, duration, log_type).to_yaml
  end
  file dump_file do
    owner owner
    group group
    content dump_content.to_yaml
  end
end
