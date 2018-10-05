include_recipe 'ciserver::ci_preparationpackages'
include_recipe 'ciserver::ngrok_install'
include_recipe 'ciserver::python_install'
include_recipe 'ciserver::endpoint_handler'
include_recipe 'ciserver::enpoint_unzip'

