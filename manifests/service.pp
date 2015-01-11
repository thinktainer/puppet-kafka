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

  $startup_file_mode = $::os ? {
    /(?i)(redhat|centos)/ => "0755",
    /(?i)(debian|ubuntu)/ => "0644",
    default               => undef
  }


  file { $startup_install_path:
    content => $startup_file_content,
    mode => $startup_file_mode,
    alias => 'kafka-init',
    require => File[$conf_file],
  }

  if $::os =~ /(?i)(centos|redhat)/{
    exec { 'chkconfig --add kafka':
      path    => ["/sbin"],
      cwd     => "/etc/rc.d/init.d",
      before  => Service["kafka"],
      require => File["$startup_install_path"]
    }
  }

  service { 'kafka':
    ensure => running,
    require => File['kafka-init'],
  }
}
