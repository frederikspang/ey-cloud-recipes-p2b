default['resque_scheduler']['is_resque_scheduler_instance'] = (node['dna']['instance_role'] == 'util' && node['dna']['name'] == 'generic_utility')
# default['resque_scheduler']['applications'] = %w[todo]
default['resque_scheduler']['worker_count'] = 2
