class kafka::service inherits kafka {

  $startup_install_path = $::os ? {
    /(?i)(redhat|centos)/ => '/etc/init.d/kafka',
    /(?i)(debian|ubuntu)/ => '/etc/init/kafka.conf',
    default               => undef
  }

  $startup_file_content = $::os ? {
    /(?i)(redhat|centos)/ => template("kafka/kafka.init.erb"),
    /(?i)(debian|ubuntu)/ => template("kafka/init/kafka.conf.erb"),
    default               => undef
  }

  file { $startup_install_path:
    content => $startup_file_content,
    mode => "0644",
    alias => 'kafka-init',
    require => File[$conf_file],
  }

  if $::os =~ /(?i)(centos|redhat)/{
    exec { 'chkconfig --add kafka':
      path   => ["/sbin"]
      before => Service["kafka"]
    }
  }

  service { 'kafka':
    ensure => running,
    require => File['kafka-init'],
  }
}
