# Public: Install and configure Apache Maven
#
# Examples
#
#   include maven

class maven (
  $version = '3.2.2'
) {

  file { "/tmp/apache-maven-${version}-bin.tar.gz":
    ensure  => present,
    require => Exec['Fetch maven'],
  }

  exec { 'Fetch maven':
    cwd     => '/tmp',
    command => "wget http://archive.apache.org/dist/maven/maven-3/${version}/binaries/apache-maven-${version}-bin.tar.gz",
    creates => "/tmp/apache-maven-${version}-bin.tar.gz",
    path    => ['/opt/boxen/homebrew/bin'],
    require => [ Package['wget'] ],
  }

  exec { 'Extract maven':
    cwd     => '/usr/local',
    command => "tar xvf /tmp/apache-maven-${version}-bin.tar.gz",
    creates => "/usr/local/apache-maven-${version}",
    path    => ['/usr/bin'],
    require => Exec['Fetch maven'],
  }

  file { "/usr/local/apache-maven-${version}":
    require => Exec['Extract maven'],
  }

  file { '/usr/local/maven':
    ensure  => link,
    target  => "/usr/local/apache-maven-${version}",
    require => File["/usr/local/apache-maven-${version}"],
  }

  file { '/opt/boxen/bin/mvn':
    ensure  => link,
    target  => '/usr/local/maven/bin/mvn',
    require => File['/usr/local/maven'],
  }

}
