include_recipe 'mirror_server::mirror_server_config'
include_recipe 'mirror_server::packages_config'
include_recipe 'mirror_server::sshd_config'
include_recipe 'mirror_server::sshd_restart'
