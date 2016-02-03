#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves an unparsed OpenStack authentication token and tenantID.
#
# Inputs:
#   - host - OpenStack machine host
#   - identity_port - optional - port used for OpenStack authentication - Default: '5000'
#   - username - OpenStack username
#   - password - OpenStack password
#   - tenant_name - name of project on OpenStack
#   - proxy_host - optional - proxy server used to access web site
#   - proxy_port - optional - proxy server port
#   - proxy_username - optional - username used when connecting to proxy
#   - proxy_password - optional - proxy server password associated with <proxy_username> input value
# Outputs:
#   - return_result - response of operation
#   - status_code - normal status code is '200'
#   - return_code - if return_code == -1 then there was an error
#   - error_message: return_result if return_code == -1 or status_code != '200'
# Results:
#   - SUCCESS - operation succeeded (return_code != '-1' and status_code == '200')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.openstack

operation:
  name: get_authentication
  inputs:
    - host
    - identity_port: '5000'
    - username
    - password
    - tenant_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - proxyHost:
        default: ${proxy_host if proxy_host is not None else ''}
        overridable: false
    - proxyPort:
        default: ${proxy_port if proxy_port is not None else ''}
        overridable: false
    - proxyUsername:
        default: ${proxy_username if proxy_username is not None else ''}
        overridable: false
    - proxyPassword:
        default: ${proxy_password if proxy_password is not None else ''}
        overridable: false
    - url:
        default: ${'http://'+ host + ':' + identity_port + '/v2.0/tokens'}
        overridable: false
    - body:
        default: >
          ${'{"auth": {"tenantName": "' + tenant_name +
          '","passwordCredentials": {"username": "' + username +
          '", "password": "' + password + '"}}}'}
        overridable: false
    - method:
        default: 'post'
        overridable: false
    - contentType:
        default: 'application/json'
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: ${returnResult}
    - status_code: ${'' if 'statusCode' not in locals() else statusCode}
    - return_code: ${returnCode}
    - error_message: ${returnResult if returnCode == '-1' or statusCode != '200' else ''}
  results:
    - SUCCESS: ${'statusCode' in locals() and returnCode != '-1' and statusCode == '200'}
    - FAILURE
