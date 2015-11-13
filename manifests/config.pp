#carbon_c_relay config
class carbon_c_relay::config (
  $port               = $::carbon_c_relay::port,
  $config_file        = $::carbon_c_relay::config_file,
  $log_file           = $::carbon_c_relay::log_file,
  $workers            = $::carbon_c_relay::workers,
  $batch_size         = $::carbon_c_relay::batch_size,
  $queue_size         = $::carbon_c_relay::queue_size,
  $statistics         = $::carbon_c_relay::statistics,
  $version            = $::carbon_c_relay::version,
) {

  file { $log_file:
    ensure      => 'present',
    owner       => 'www-data',
    group       => 'www-data',
  }

  file { '/etc/init.d/relay':
    ensure      => 'present',
    owner       => 'root',
    group       => 'root',
    mode        => '0755',
    content     => template('carbon_c_relay/relay.init.erb')
  }

  concat { $config_file:
    ensure      => present,
    owner       => 'root',
    group       => 'root',
    mode        => '0644',
    notify      => Service['relay']
  }

  concat::fragment { '01-relay-header':
    target      => $config_file,
    order       => '01',
    content     => "# This file managed by Puppet\n",
  }

}
