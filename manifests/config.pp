class kafka::config (
  $conf_file = $kafka::conf_file
)  inherits kafka {

  
  file { $conf_file:
    owner => 'kafka',
    group => 'kafka',
    mode => "644",
    alias => "kafka-cfg",
    require => File["kafka-app-dir"],
    content => template("kafka/config/server.properties.erb"),
  }
  
}
