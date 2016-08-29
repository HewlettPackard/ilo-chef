ilo1 =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_https_cert 'import certificate' do
  ilo ilo1
  file_path '/ilo_example_file.crt'
  action :import
end
