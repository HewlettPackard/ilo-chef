actions :clear, :dump

pproperty :ilos, Array, :required => true
property :log_type, String, :required => true, :equal_to => ["IEL", "IML"]
property :severity_level, String, :equal_to => ["OK","Warning","Critical"]
property :dump_file, String, :required => true
property :duration_in_hours, Integer, :required => true, :default => 24

include ClientHelper

action :clear do
  ilos.each do |ilo|
    client = build_client(ilo)
    next if logs_empty?(dump_file)
    converge_by "Clear ilo #{client.host} #{log_type} logs" do
      clear_logs(log_type)
    end
  end
end

action :dump do

end
