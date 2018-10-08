include_recipe 'client::hosts_config'
include_recipe 'client::delete_repos'
include_recipe 'client::repo_config'
include_recipe 'client::make_yum'
