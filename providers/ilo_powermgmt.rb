use_inline_resources
include RestAPI::Helper

action :poweron do
  newAction = {"Action"=> "Reset", "ResetType"=> "On"}
  options = {'body' => newAction}
  machine = new_resource.machine
  rest_api(:post, '/rest/v1/systems/1', machine, options )
end

action :poweroff do
  newAction = {"Action"=> "Reset", "ResetType"=> "ForceOff"}
  options = {'body' => newAction}
  machine = new_resource.machine
  rest_api(:post, '/rest/v1/systems/1', machine, options )
end

action :resetsys do
  newAction = {"Action"=> "Reset", "ResetType"=> "ForceRestart"}
  options = {'body' => newAction}
  machine = new_resource.machine
  rest_api(:post, '/rest/v1/systems/1', machine, options )
end
