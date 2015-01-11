class kafka::config inherits kafka {

  $conf_file = "${install_dir}/kafka/config/server.properties"
  
  file { $conf_file:
    owner => 'kafka',
    group => 'kafka',
    mode => "644",
    alias => "kafka-cfg",
    require => File["kafka-app-dir"],
    content => template("kafka/config/server.properties.erb"),
  }
  
}
