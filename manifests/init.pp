class kafka (
  $broker_id,
  $hostname             = $kafka::params::hostname,
  $zookeeper_connect    = $kafka::params::zookeeper_connect,
  $package_dir          = $kafka::params::package_dir,
  $package_url          = $kafka::params::package_url,
  $install_dir          = $kafka::params::install_dir,
  $statsd_host          = $kafka::params::statsd_host,
  $statsd_port          = $kafka::params::statsd_port,
  $conf_file            = $kafka::params::conf_file,
  $statsd_exclude_regex = $kafka::params::statsd_exclude_regex,
  $conf_file            = "${install_dir}/kafka/config/server.properties"
) inherits kafka::params {


  anchor { 'kafka::begin': } ->
  class { '::kafka::package': } ->
  class { '::kafka::install': } ->
  class { '::kafka::config': } ~>
  class { '::kafka::service': } ->
  anchor { 'kafka::end': }

}
