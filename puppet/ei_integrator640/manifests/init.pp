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

# Class: ei_integrator640
# Init class of EI Integrator default profile
class ei_integrator640 inherits ei_integrator640::params {

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

  # Ensure the installation directory is available
  file { "/opt/${product}":
    ensure => 'directory',
    owner  => $user,
    group  => $user_group,
  }

  file { "/usr/lib/wso2/":
    ensure => directory,
    owner  => $user,
    group  => $user_group,
  }

  file { "/usr/lib/wso2/wso2ei":
    ensure => directory,
    owner  => $user,
    group  => $user_group,
  }

  file { "/usr/lib/wso2/wso2ei/6.4.0/":
    ensure => directory,
    owner  => $user,
    group  => $user_group,
  }

  # Copy the relevant installer to the /opt/is directory
  file { "/usr/lib/wso2/wso2ei/6.4.0/${ei_package}":
    owner  => $user,
    group  => $user_group,
    mode   => '0644',
    source => "puppet:///modules/installers/${ei_package}",
  }

  # Install WSO2 Identity Server
  exec { 'unzip':
    command => 'unzip wso2ei-6.4.0.zip',
    cwd     => '/usr/lib/wso2/wso2ei/6.4.0/',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

  #jdk JDK
  file { "/usr/lib/wso2/wso2ei/6.4.0/${jdk_type}":
    owner  => $user,
    group  => $user_group,
    mode   => '0644',
    source => "puppet:///modules/installers/${jdk_type}",
  }

  # Install WSO2 Identity Server
  exec { 'tar':
    command => "tar -xvf ${jdk_type}",
    cwd     => '/usr/lib/wso2/wso2ei/6.4.0/',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }


  # Copy configuration changes to the installed directory
  $template_list.each | String $template | {
    file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/${template}":
      ensure  => file,
      owner   => $user,
      group   => $user_group,
      mode    => '0644',
      content => template("${module_name}/carbon-home/${template}.erb")
    }
  }

  # Copy wso2server.sh to installed directory
  file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/${start_script_template}":
    ensure  => file,
    owner   => $user,
    group   => $user_group,
    mode    => '0754',
    content => template("${module_name}/carbon-home/${start_script_template}.erb")
  }

  # Copy mysql connector to the installed directory
  file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/lib/${db_connector}":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/${db_connector}",
  }

  #  #  Copy groovy jar to the installed directory
 file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/dropins/groovy-all-2.2.0.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/groovy-all-2.2.0.jar",
  }

  #  #  Copy customer 14.2-customJavaTaskToRunWithInterval-6.4.0.jar to the libs directory
  file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/lib/14.2-customJavaTaskToRunWithInterval-6.4.0.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/14.2-customJavaTaskToRunWithInterval-6.4.0.jar",
  }

  # Copy activeio-core jar to the installed directory for ActiveMQ integration
  file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/lib/activeio-core-3.1.4.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/activeio-core-3.1.4.jar",
  }

  # Copy activemq-broker jar to the installed directory for ActiveMQ integration
  file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/lib/activemq-broker-5.15.8.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/activemq-broker-5.15.8.jar",
  }

  # Copy activemq-client jar to the installed directory for ActiveMQ integration
  file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/lib/activemq-client-5.15.8.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/activemq-client-5.15.8.jar",
  }

  # Copy activemq-kahadb-store jar to the installed directory for ActiveMQ integration
  file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/lib/activemq-kahadb-store-5.15.8.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/activemq-kahadb-store-5.15.8.jar",
  }

  # Copy geronimo-j2ee-management_1.1_spec jar to the installed directory for ActiveMQ integration
  file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/lib/geronimo-j2ee-management_1.1_spec-1.0.1.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/geronimo-j2ee-management_1.1_spec-1.0.1.jar",
  }

  # Copy geronimo-jms_1.1_spec jar to the installed directory for ActiveMQ integration
  file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/lib/geronimo-jms_1.1_spec-1.1.1.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/geronimo-jms_1.1_spec-1.1.1.jar",
  }

  # Copy geronimo-jta jar to the installed directory for ActiveMQ integration
  file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/lib/geronimo-jta_1.0.1B_spec-1.0.1.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/geronimo-jta_1.0.1B_spec-1.0.1.jar",
  }

  # Copy hawtbuf jar to the installed directory for ActiveMQ integration
  file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/lib/hawtbuf-1.11.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/hawtbuf-1.11.jar",
  }

  # Copy slf4j-api jar to the installed directory for ActiveMQ integration
  file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/lib/slf4j-api-1.7.25.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/slf4j-api-1.7.25.jar",
  }

  file { "/usr/local/bin/private_ip_extractor.py":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/private_ip_extractor.py",
  }

  # Copy the unit file required to deploy the server as a service
  file { "/etc/systemd/system/${service_name}.service":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0754',
    content => template("${module_name}/${service_name}.service.erb"),
  }

  /*
    Following script can be used to copy file to a given location.
    This will copy some_file to install_path -> repository.
    Note: Ensure that file is available in modules -> ei_integrator640 -> files
  */
  # file { "${install_path}/repository/some_file":
  #   owner  => $user,
  #   group  => $user_group,
  #   mode   => '0644',
  #   source => "puppet:///modules/${module_name}/some_file",
  # }

    # Copy jacoco agent to the installed directory
    file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/lib/jacocoagent.jar":
      owner  => $user,
      group  => $user_group,
      mode   => '0754',
      source => "puppet:///modules/installers/jacocoagent.jar",
    }
}
