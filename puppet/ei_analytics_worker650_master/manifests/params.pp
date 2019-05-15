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

# Claas ei_analytics_worker650_master::params
# This class includes all the necessary parameters.
class ei_analytics_worker650_master::params {
  $user = 'wso2carbon'
  $user_group = 'wso2'
  $product = 'wso2ei'
  $product_version = '6.5.0'
  $profile = 'analytics-worker'
  $user_id = 802
  $ports_offset = 0
  $user_home = '/home/$user'
  $user_group_id = 802
  $enable_test_mode = 'ENABLE_TEST_MODE'
  $hostname = 'localhost'
  $mgt_hostname = 'localhost'
  $jdk_version = 'JDK_TYPE'
  $db_managment_system = 'CF_DBMS'
  $oracle_sid = 'WSO2EIDB'
  $db_password = 'CF_DB_PASSWORD'
  $ei_package = 'wso2ei-6.5.0.zip'

  # Define the template
  $template_list = [
    'wso2/analytics/conf/worker/deployment.yaml'
  ]

  # -------------- Deployment.yaml Config -------------- #

  # Carbon Configuration Parameters
  $ports_offset = 0

  # transport.http config
  $default_listener_host = '0.0.0.0'
  $msf4j_host = '0.0.0.0'
  $msf4j_listener_keystore = '${carbon.home}/resources/security/wso2carbon.jks'
  $msf4j_listener_keystore_password = 'wso2carbon'
  $msf4j_listener_keystore_cert_pass = 'wso2carbon'

  # siddhi.stores.query.api config
  $siddhi_default_listener_host = '0.0.0.0'
  $siddhi_msf4j_host = '0.0.0.0'
  $siddhi_msf4j_listener_keystore = '${carbon.home}/resources/security/wso2carbon.jks'
  $siddhi_msf4j_listener_keystore_password = 'wso2carbon'
  $siddhi_msf4j_listener_keystore_cert_pass = 'wso2carbon'

  # Configuration used for the databridge communication
  $databridge_keystore = '${sys:carbon.home}/resources/security/wso2carbon.jks'
  $databridge_keystore_password = 'wso2carbon'
  $binary_data_receiver_hostname = '0.0.0.0'

  # Configuration of the Data Agents - to publish events through
  $thrift_agent_trust_store = '${sys:carbon.home}/resources/security/client-truststore.jks'
  $thrift_agent_trust_store_password = 'wso2carbon'
  $binary_agent_trust_store = '${sys:carbon.home}/resources/security/client-truststore.jks'
  $binary_agent_trust_store_password = 'wso2carbon'

  # Secure Vault Configuration
  $securevault_key_store = '${sys:carbon.home}/resources/security/securevault.jks'
  $securevault_private_key_alias = 'wso2carbon'
  $securevault_secret_properties_file = '${sys:carbon.home}/conf/${sys:wso2.runtime}/secrets.properties'
  $securevault_master_key_reader_file = '${sys:carbon.home}/conf/${sys:wso2.runtime}/master-keys.yaml'

  if $db_managment_system == 'mysql' {
    $ei_analytics_db_username = 'CF_DB_USERNAME'
    $ei_carbon_db_username = 'CF_DB_USERNAME'
    $persistence_db_username = 'CF_DB_USERNAME'
    $metrics_db_username = 'CF_DB_USERNAME'
    $ei_analytics_db_url = 'jdbc:mysql://CF_RDS_URL:3306/EI_ANALYTICS_DB?useSSL=false'
    $ei_carbon_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2_CARBON_DB?useSSL=false'
    $persistence_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2_PERSISTENCE_DB?useSSL=false'
    $metrics_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2_METRICS_DB?useSSL=false'
    $db_driver_class_name = 'com.mysql.jdbc.Driver'
    $db_connector = 'mysql-connector-java-5.1.41-bin.jar'
    $db_validation_query = 'SELECT 1'

  } elsif $db_managment_system =~ 'oracle' {
    $ei_analytics_db_username = 'EI_ANALYTICS_DB'
    $ei_carbon_db_username = 'WSO2_CARBON_DB'
    $persistence_db_username = 'WSO2_PERSISTENCE_DB'
    $metrics_db_username = 'WSO2_METRICS_DB'
    $ei_analytics_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $ei_carbon_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $persistence_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $metrics_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $db_driver_class_name = 'oracle.jdbc.OracleDriver'
    $db_validation_query = 'SELECT 1 FROM DUAL'
    $db_connector = 'ojdbc8_1.0.0.jar'

  } elsif $db_managment_system == 'sqlserver-se' {
    $ei_analytics_db_username = 'CF_DB_USERNAME'
    $ei_carbon_db_username = 'CF_DB_USERNAME'
    $persistence_db_username = 'CF_DB_USERNAME'
    $metrics_db_username = 'CF_DB_USERNAME'
    $ei_analytics_db_url = 'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=EI_ANALYTICS_DB;SendStringParametersAsUnicode=false'
    $ei_carbon_db_url = 'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=WSO2_CARBON_DB;SendStringParametersAsUnicode=false'
    $persistence_db_url = 'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=WSO2_PERSISTENCE_DB;SendStringParametersAsUnicode=false'
    $metrics_db_url = 'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=WSO2_METRICS_DB;SendStringParametersAsUnicode=false'
    $db_driver_class_name = 'com.microsoft.sqlserver.jdbc.SQLServerDriver'
    $db_connector = 'mssql-jdbc-7.0.0.jre8.jar'
    $db_validation_query = 'SELECT 1'

  } elsif $db_managment_system == 'postgres' {
    $ei_analytics_db_username = 'CF_DB_USERNAME'
    $ei_carbon_db_username = 'CF_DB_USERNAME'
    $persistence_db_username = 'CF_DB_USERNAME'
    $metrics_db_username = 'CF_DB_USERNAME'
    $ei_analytics_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/EI_ANALYTICS_DB'
    $ei_carbon_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/WSO2_CARBON_DB'
    $persistence_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/WSO2_PERSISTENCE_DB'
    $metrics_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/WSO2_METRICS_DB'
    $db_driver_class_name = 'org.postgresql.Driver'
    $db_connector = 'postgresql-42.2.5.jar'
    $db_validation_query = 'SELECT 1; COMMIT'
  }

  $ei_analytics_db = {
    url               => $ei_analytics_db_url,
    username          => $ei_analytics_db_username,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }

  $ei_carbon_db = {
    url               => $ei_carbon_db_url,
    username          => $ei_carbon_db_username,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }

  $persistence_db = {
    url               => $persistence_db_url,
    username          => $persistence_db_username,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }

  $metrics_db = {
    url               => $metrics_db_url,
    username          => $metrics_db_username,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }


  # Directories
  $products_dir = "/usr/local/wso2"

  # Product and installation paths
  $product_binary = "${product}-${product_version}.zip"
  $distribution_path = "${products_dir}/${product}/${profile}/${product_version}"
  $install_path = "${distribution_path}/${product}-${product_version}"
}
