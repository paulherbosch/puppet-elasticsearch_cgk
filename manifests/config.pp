class elasticsearch_cgk::config(
  $cluster_name = 'elasticsearch',
  $data_dir = '/data/elasticsearch',
  $logs_dir = '/data/logs/elasticsearch'
) {

  file { $data_dir:
    ensure => directory,
    owner  => 'elasticsearch',
    group  => 'elasticsearch',
    mode   => '0755'
  }

  file { $logs_dir:
    ensure => directory,
    owner  => 'elasticsearch',
    group  => 'elasticsearch',
    mode   => '0755'
  }

  file { '/etc/elasticsearch/elasticsearch.yml':
    ensure  => file,
    content => template("${module_name}/etc/elasticsearch/elasticsearch.yml.erb"),
    mode    => '0644'
  }

  file { '/etc/elasticsearch/logging.yml':
    ensure  => file,
    content => template("${module_name}/etc/elasticsearch/logging.yml.erb"),
    mode    => '0644'
  }

  file { '/etc/sysconfig/elasticsearch':
    ensure  => file,
    content => template("${module_name}/etc/sysconfig/elasticsearch.erb"),
    mode    => '0644'
  }
}
