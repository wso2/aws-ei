# ----------------------------------------------------------------------------
#  Copyright (c) 2018 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ----------------------------------------------------------------------------

# Class: ei_integrator650
# Init class of EI Integrator default profile
class ei_integrator650 inherits ei_integrator650::params {

  if $jdk_version == 'ORACLE_JDK8' {
    $jdk_type = "jdk-8u144-linux-x64.tar.gz"
    $jdk_path = "jdk1.8.0_144"
  }
  elsif $jdk_version == 'OPEN_JDK8' {
    $jdk_type = "jdk-8u192-ea-bin-b02-linux-x64-19_jul_2018.tar.gz"
    $jdk_path = "jdk1.8.0_192"
  }
  elsif $jdk_version == 'Corretto_JDK8' {
    $jdk_type = "amazon-corretto-8.202.08.2-linux-x64.tar.gz"
    $jdk_path = "amazon-corretto-8.202.08.2-linux-x64"
  }

  # Create wso2 group
  group { $user_group:
    ensure => present,
    gid    => $user_group_id,
    system => true,
  }

  # Create wso2 user
  user { $user:
    ensure => present,
    uid    => $user_id,
    gid    => $user_group_id,
    home   => "/home/${user}",
    system => true,
  }

  # Copy JDK distrubution path
  file { "${$lib_dir}":
    ensure => directory
  }

  # Copy JDK to Java distribution path
  file { "jdk-distribution":
    path   => "${java_home}.tar.gz",
    source => "puppet:///modules/installers/${jdk_type}.tar.gz",
  }

  # Unzip distribution
  exec { "unpack-jdk":
    command => "tar -zxvf ${java_home}.tar.gz",
    path    => "/bin/",
    cwd     => "${lib_dir}",
    onlyif  => "/usr/bin/test ! -d ${java_home}",
  }

  # Create distribution path
  file { [  "${products_dir}",
    "${products_dir}/${product}/${profile}" ]:
    ensure => 'directory',
  }

  # Change the ownership of the installation directory to specified user & group
  file { $distribution_path:
    ensure  => directory,
    owner   => $user,
    group   => $user_group,
    require => [ User[$user], Group[$user_group]],
    recurse => true
  }

  # Copy binary to distribution path
  file { "binary":
    path   => "$distribution_path/${product_binary}",
    owner  => $user,
    group  => $user_group,
    mode   => '0644',
    source => "puppet:///modules/ei_integrator650/${product_binary}",
  }

  # Stop the existing setup
  exec { "stop-server":
    command     => "kill -term $(cat ${install_path}/wso2carbon.pid)",
    path        => "/bin/",
    onlyif      => "/usr/bin/test -f ${install_path}/wso2carbon.pid",
    subscribe   => File["binary"],
    refreshonly => true,
  }

  # Wait for the server to stop
  exec { "wait":
    command     => "sleep 10",
    path        => "/bin/",
    onlyif      => "/usr/bin/test -d ${install_path}",
    subscribe   => File["binary"],
    refreshonly => true,
  }

  # Delete existing setup
  exec { "detele-pack":
    command     => "rm -rf ${install_path}",
    path        => "/bin/",
    onlyif      => "/usr/bin/test -d ${install_path}",
    subscribe   => File["binary"],
    refreshonly => true,
  }

  # Install the "unzip" package
  package { 'unzip':
    ensure => installed,
  }

  # Unzip the binary and create setup
  exec { "unzip-update":
    command     => "unzip -qo ${product_binary}",
    path        => "/usr/bin/",
    user        => $user,
    cwd         => "${distribution_path}",
    onlyif      => "/usr/bin/test ! -d ${install_path}",
    subscribe   => File["binary"],
    refreshonly => true,
    require     => Package['unzip'],
  }

  # Copy wso2server.sh to installed directory
  file { "${install_path}/${start_script_template}":
    ensure  => file,
    owner   => $user,
    group   => $user_group,
    mode    => '0754',
    content => template("${module_name}/carbon-home/${start_script_template}.erb")
  }

  # Add agent specific file configurations
  $config_file_list.each |$config_file| {
    exec { "sed -i -e 's/${config_file['key']}/${config_file['value']}/g' ${config_file['file']}":
      path => "/bin/",
    }
  }

  #  Copy groovy jar to the installed directory
  file { "${install_path}/dropins/groovy-all-2.2.0.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/groovy-all-2.2.0.jar",
  }

  #  #  Copy customer 14.2-customJavaTaskToRunWithInterval-6.5.0.jar to the libs directory
  file { "${install_path}/lib/14.2-customJavaTaskToRunWithInterval-6.4.0.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/14.2-customJavaTaskToRunWithInterval-6.4.0.jar",
  }

  # Copy activeio-core jar to the installed directory for ActiveMQ integration
  file { "${install_path}/lib/activeio-core-3.1.4.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/activeio-core-3.1.4.jar",
  }

  # Copy activemq-broker jar to the installed directory for ActiveMQ integration
  file { "${install_path}/lib/activemq-broker-5.15.8.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/activemq-broker-5.15.8.jar",
  }

  # Copy activemq-client jar to the installed directory for ActiveMQ integration
  file { "${install_path}/lib/activemq-client-5.15.8.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/activemq-client-5.15.8.jar",
  }

  # Copy activemq-kahadb-store jar to the installed directory for ActiveMQ integration
  file { "${install_path}/lib/activemq-kahadb-store-5.15.8.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/activemq-kahadb-store-5.15.8.jar",
  }

  # Copy geronimo-j2ee-management_1.1_spec jar to the installed directory for ActiveMQ integration
  file { "${install_path}/lib/geronimo-j2ee-management_1.1_spec-1.0.1.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/geronimo-j2ee-management_1.1_spec-1.0.1.jar",
  }

  # Copy geronimo-jms_1.1_spec jar to the installed directory for ActiveMQ integration
  file { "${install_path}/lib/geronimo-jms_1.1_spec-1.1.1.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/geronimo-jms_1.1_spec-1.1.1.jar",
  }

  # Copy geronimo-jta jar to the installed directory for ActiveMQ integration
  file { "${install_path}/lib/geronimo-jta_1.0.1B_spec-1.0.1.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/geronimo-jta_1.0.1B_spec-1.0.1.jar",
  }

  # Copy hawtbuf jar to the installed directory for ActiveMQ integration
  file { "${install_path}/lib/hawtbuf-1.11.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/hawtbuf-1.11.jar",
  }

  # Copy slf4j-api jar to the installed directory for ActiveMQ integration
  file { "${install_path}/lib/slf4j-api-1.7.25.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/slf4j-api-1.7.25.jar",
  }

  /*
    Following script can be used to copy file to a given location.
    This will copy some_file to install_path -> repository.
    Note: Ensure that file is available in modules -> ei_integrator650 -> files
  */
  # file { "${install_path}/repository/some_file":
  #   owner  => $user,
  #   group  => $user_group,
  #   mode   => '0644',
  #   source => "puppet:///modules/${module_name}/some_file",
  # }

  # Copy jacoco agent to the installed directory
  file { "${install_path}/lib/jacocoagent.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/jacocoagent.jar",
  }
}
