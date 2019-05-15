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

# Claas ei_broker650_master::params
# This class includes all the necessary parameters.
class ei_broker650_master::params {

  $user = 'wso2carbon'
  $user_id = 802
  $user_group = 'wso2'
  $user_home = '/home/$user'
  $user_group_id = 802
  $hostname = 'CF_ELB_DNS_NAME'
  $mgt_hostname = 'CF_ELB_DNS_NAME'
  $db_managment_system = 'CF_DBMS'
  $oracle_sid = 'WSO2EIDB'
  $db_password = 'CF_DB_PASSWORD'
  $aws_access_key = 'access-key'
  $aws_secret_key = 'secretkey'
  $aws_region = 'REGION_NAME'
  $local_member_host = 'local_ip'
  $http_proxy_port = '80'
  $https_proxy_port = '443'
  $product = 'wso2ei'
  $product_version = '6.5.0'
  $profile = 'broker'
  $service_name = "${product}-${profile}"
  $thriftServerHost = 'CF_ELB_DNS_NAME'
  $ei_package = 'wso2ei-6.5.0.zip'

  # Define the template
  $start_script_template = "wso2/broker/bin/wso2server.sh"
  $template_list = [
    'wso2/broker/conf/broker.xml',
    'wso2/broker/conf/datasources/master-datasources.xml',
    'wso2/broker/conf/carbon.xml',
    'wso2/broker/conf/axis2/axis2.xml',
    'wso2/broker/conf/user-mgt.xml',
    'wso2/broker/conf/registry.xml',
    'wso2/broker/conf/log4j.properties',
    'wso2/broker/conf/hazelcast.properties',
    'wso2/broker/conf/tomcat/catalina-server.xml',
  ]

  # ------ Configuration Params ------ #

  # broker.xml
  $amqp_keystore_location = 'repository/resources/security/wso2carbon.jks'
  $amqp_keystore_password = 'wso2carbon'
  $amqp_keystore_cert_type = 'SunX509'

  $amqp_trust_store_location = 'repository/resources/security/client-truststore.jks'
  $amqp_trust_store_password = 'wso2carbon'
  $amqp_trust_store_cert_type = 'SunX509'

  $mqtt_keystore_location = 'repository/resources/security/wso2carbon.jks'
  $mqtt_keystore_password = 'wso2carbon'
  $mqtt_keystore_cert_type = 'SunX509'

  $mqtt_trust_store_location = 'repository/resources/security/client-truststore.jks'
  $mqtt_trust_store_password = 'wso2carbon'
  $mqtt_trust_store_cert_type = 'SunX509'

  # master-datasources.xml
  $mb_store_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2_MB_DB?autoReconnect=true&amp;useSSL=false'
  $mb_store_db_username = 'CF_DB_USERNAME'
  $mb_store_db_password = 'CF_DB_PASSWORD'

  $mb_reg_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2_CONFIG_GOV_DB?autoReconnect=true&amp;useSSL=false'
  $mb_reg_db_username = 'CF_DB_USERNAME'
  $mb_reg_db_password = 'CF_DB_PASSWORD'

  $mb_user_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2_USER_DB?autoReconnect=true&amp;useSSL=false'
  $mb_user_db_username = 'CF_DB_USERNAME'
  $mb_user_db_password = 'CF_DB_PASSWORD'

  if $db_managment_system == 'mysql' {
    $reg_db_user_name = 'CF_DB_USERNAME'
    $um_db_user_name = 'CF_DB_USERNAME'
    $wso2_reg_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2_CONFIG_GOV_DB?autoReconnect=true&amp;useSSL=false'
    $wso2_um_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2_USER_DB?autoReconnect=true&amp;useSSL=false'
    $wso2_mb_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2_MB_DB?autoReconnect=true&amp;useSSL=false'
    $mb_db_user_name = 'CF_DB_USERNAME'
    $db_driver_class_name = 'com.mysql.jdbc.Driver'
    $db_connector = 'mysql-connector-java-5.1.41-bin.jar'
    $db_validation_query = 'SELECT 1'
  } elsif $db_managment_system =~ 'oracle' {
    $reg_db_user_name = 'WSO2_CONFIG_GOV_DB'
    $um_db_user_name = 'WSO2_USER_DB'
    $wso2_reg_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $wso2_um_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $wso2_mb_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $mb_db_user_name = 'WSO2_MB_DB'
    $db_driver_class_name = 'oracle.jdbc.OracleDriver'
    $db_validation_query = 'SELECT 1 FROM DUAL'
    $db_connector = 'ojdbc8.jar'
  } elsif $db_managment_system == 'sqlserver-se' {
    $reg_db_user_name = 'CF_DB_USERNAME'
    $um_db_user_name = 'CF_DB_USERNAME'
    $wso2_reg_db_url = 'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=WSO2_CONFIG_GOV_DB;SendStringParametersAsUnicode=false'
    $wso2_um_db_url = 'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=WSO2_USER_DB;SendStringParametersAsUnicode=false'
    $wso2_mb_db_url = 'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=WSO2_MB_DB;SendStringParametersAsUnicode=false'
    $mb_db_user_name = 'CF_DB_USERNAME'
    $db_driver_class_name = 'com.microsoft.sqlserver.jdbc.SQLServerDriver'
    $db_connector = 'mssql-jdbc-7.0.0.jre8.jar'
    $db_validation_query = 'SELECT 1'
  } elsif $db_managment_system == 'postgres' {
    $reg_db_user_name = 'CF_DB_USERNAME'
    $um_db_user_name = 'CF_DB_USERNAME'
    $wso2_reg_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/WSO2_CONFIG_GOV_DB'
    $wso2_um_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/WSO2_USER_DB'
    $wso2_mb_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/WSO2_MB_DB'
    $mb_db_user_name = 'CF_DB_USERNAME'
    $db_driver_class_name = 'org.postgresql.Driver'
    $db_connector = 'postgresql-42.2.5.jar'
    $db_validation_query = 'SELECT 1; COMMIT'
  }

  $mb_user_db = {
    url               => $wso2_um_db_url,
    username          => $um_db_user_name,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }

  $mb_reg_db = {
    url               => $wso2_reg_db_url,
    username          => $reg_db_user_name,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }

  $mb_store_db = {
    url               => $wso2_mb_db_url,
    username          => $mb_db_user_name,
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

  # user-mgt.xml
  $admin_username = 'admin'
  $admin_password = 'admin'
}
