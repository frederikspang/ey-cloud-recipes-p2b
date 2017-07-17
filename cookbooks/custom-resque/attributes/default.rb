default['resque']['is_resque_instance'] = (node['dna']['instance_role'] == 'util' && node['dna']['name'] == 'generic_utility')
# default['resque']['applications'] = %w[todo]
default['resque']['worker_count'] = 4
