actions :create, :delete, :changePassword

property :ilos, Array, required: true
property :username, String
property :password, String

action_class do
  include IloHelper
end

action :create do
  load_sdk
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_users = client.get_users
    next if cur_users.include? username
    converge_by "Create user #{username} on ilo #{client.host}" do
      client.create_user(username, password)
    end
  end
end

action :delete do
  load_sdk
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_users = client.get_users
    next unless cur_users.include? username
    converge_by "Delete user #{username} on ilo #{client.host}'" do
      client.delete_user(username)
    end
  end
end

action :changePassword do
  load_sdk
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_users = client.get_users
    next unless cur_users.include? username
    converge_by "Change password for user #{username} on ilo #{client.host}" do
      client.change_password(username, password)
    end
  end
end
