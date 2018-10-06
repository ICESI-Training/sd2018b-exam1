include_recipe 'mirror_server::mirror_config'
include_recipe 'mirror_server::install_packages'
include_recipe 'mirror_server::copy_archivos'
include_recipe 'mirror_server::activate_ssh'
