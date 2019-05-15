# ----------------------------------------------------------------------------
#  Copyright (c) 2019 WSO2, Inc. http://www.wso2.org
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

# Claas ei_integrator650_master::params
# This class includes all the necessary parameters.
class ei_integrator650_master::params {

  $user = 'wso2carbon'
  $user_group = 'wso2'
  $product = 'wso2ei'
  $product_version = '6.5.0'
  $profile = 'integrator'
  $user_id = 802
  $user_home = '/home/$user'
  $user_group_id = 802
  $hostname = 'CF_ELB_DNS_NAME'
  $mgt_hostname = 'CF_ELB_DNS_NAME'
  $jdk_version = 'JDK_TYPE'
  $db_managment_system = 'CF_DBMS'
  $oracle_sid = 'WSO2EIDB'
  $db_password = 'CF_DB_PASSWORD'
  $aws_access_key = 'access-key'
  $aws_secret_key = 'secretkey'
  $aws_region = 'REGION_NAME'
  $local_member_host = 'local_ip'
  $http_proxy_port = '80'
  $https_proxy_port = '443'
  $service_name = "${product}-${profile}"
  $ei_analytics = 'CF_ANALYTICS_IP'
  $mediation_flow_statistics = 'false'
  $broker_elb_dns_name = 'BROKER_ELB_DNS_NAME'
  $ei_package = 'wso2ei-6.4.0.zip'

  # Define the template
  $template_list = [
    'conf/datasources/master-datasources.xml',
    'conf/carbon.xml',
    'conf/axis2/axis2.xml',
    'conf/user-mgt.xml',
    'conf/registry.xml',
    'conf/tomcat/catalina-server.xml',
    'conf/synapse.properties',
    'conf/jndi.properties',
    'repository/deployment/server/eventpublishers/MessageFlowConfigurationPublisher.xml',
    'repository/deployment/server/eventpublishers/MessageFlowStatisticsPublisher.xml',
  ]

  # ------ Configuration Params ------ #

  if $db_managment_system == 'mysql' {
    $reg_db_user_name = 'CF_DB_USERNAME'
    $um_db_user_name = 'CF_DB_USERNAME'
    $wso2_reg_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2EI_INTEGRATOR_GOV_DB?autoReconnect=true&amp;useSSL=false'
    $wso2_um_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2EI_USER_DB?autoReconnect=true&amp;useSSL=false'
    $db_driver_class_name = 'com.mysql.jdbc.Driver'
    $db_connector = 'mysql-connector-java-5.1.41-bin.jar'
    $db_validation_query = 'SELECT 1'
  } elsif $db_managment_system =~ 'oracle' {
    $reg_db_user_name = 'WSO2EI_INTEGRATOR_GOV_DB'
    $um_db_user_name = 'WSO2EI_USER_DB'
    $wso2_reg_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $wso2_um_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $db_driver_class_name = 'oracle.jdbc.OracleDriver'
    $db_validation_query = 'SELECT 1 FROM DUAL'
    $db_connector = 'ojdbc8.jar'
  } elsif $db_managment_system == 'sqlserver-se' {
    $reg_db_user_name = 'CF_DB_USERNAME'
    $um_db_user_name = 'CF_DB_USERNAME'
    $wso2_reg_db_url =
      'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=WSO2EI_INTEGRATOR_GOV_DB;SendStringParametersAsUnicode=false'
    $wso2_um_db_url = 'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=WSO2EI_USER_DB;SendStringParametersAsUnicode=false'
    $db_driver_class_name = 'com.microsoft.sqlserver.jdbc.SQLServerDriver'
    $db_connector = 'mssql-jdbc-7.0.0.jre8.jar'
    $db_validation_query = 'SELECT 1'
  } elsif $db_managment_system == 'postgres' {
    $reg_db_user_name = 'CF_DB_USERNAME'
    $um_db_user_name = 'CF_DB_USERNAME'
    $wso2_reg_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/WSO2EI_INTEGRATOR_GOV_DB'
    $wso2_um_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/WSO2EI_USER_DB'
    $db_driver_class_name = 'org.postgresql.Driver'
    $db_connector = 'postgresql-42.2.5.jar'
    $db_validation_query = 'SELECT 1; COMMIT'
  }

  $wso2_um_db = {
    url               => $wso2_um_db_url,
    username          => $um_db_user_name,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }

  $wso2_reg_db = {
    url               => $wso2_reg_db_url,
    username          => $reg_db_user_name,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }

  # carbon.xml
  $security_keystore_location = '${carbon.home}/repository/resources/security/wso2carbon.jks'
  $security_keystore_type = 'JKS'
  $security_keystore_password = 'wso2carbon'
  $security_keystore_key_alias = 'wso2carbon'
  $security_keystore_key_password = 'wso2carbon'

  $security_trust_store_location = '${carbon.home}/repository/resources/security/client-truststore.jks'
  $security_trust_store_type = 'JKS'
  $security_trust_store_password = 'wso2carbon'

  # axis2.xml
  $transport_receiver_keystore_location = 'repository/resources/security/wso2carbon.jks'
  $transport_receiver_keystore_type = 'JKS'
  $transport_receiver_keystore_password = 'wso2carbon'
  $transport_receiver_keystore_key_password = 'wso2carbon'

  $transport_receiver_trust_store_location = 'repository/resources/security/client-truststore.jks'
  $transport_receiver_trust_store_type = 'JKS'
  $transport_receiver_trust_store_password = 'wso2carbon'

  $transport_sender_keystore_location = 'repository/resources/security/wso2carbon.jks'
  $transport_sender_keystore_type = 'JKS'
  $transport_sender_keystore_password = 'wso2carbon'
  $transport_sender_keystore_key_password = 'wso2carbon'

  $transport_sender_trust_store_location = 'repository/resources/security/client-truststore.jks'
  $transport_sender_trust_store_type = 'JKS'
  $transport_sender_trust_store_password = 'wso2carbon'

  $transport_sender_jms_provider_url_hostname = 'ACTIVEMQ_HOSTNAME'
  $transport_sender_rabbitmq_url_hostname = 'RABBITMQ_HOSTNAME'

  # user-mgt.xml
  $admin_username = 'admin'
  $admin_password = 'admin'

  # Directories
  $products_dir = "/usr/local/wso2"

  # Product and installation paths
  $product_binary = "${product}-${product_version}.zip"
  $distribution_path = "${products_dir}/${product}/${profile}/${product_version}"
  $install_path = "${distribution_path}/${product}-${product_version}"
}
