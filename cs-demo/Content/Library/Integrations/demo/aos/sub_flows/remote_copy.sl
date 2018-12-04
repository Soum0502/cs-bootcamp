namespace: Integrations.demo.aos.sub_flows
flow:
  name: remote_copy
  inputs:
    - host
    - username
    - password
    - url
  workflow:
    - extract_filename:
        do:
          io.cloudslang.demo.aos.tools.extract_filename:
            - url: '${url}'
        publish:
          - filename
        navigate:
          - SUCCESS: get_file
    - get_file:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - auth_type: null
            - destination_file: '${filename}'
            - method: GET
        publish: []
        navigate:
          - SUCCESS: remote_secure_copy
          - FAILURE: on_failure
    - remote_secure_copy:
        do:
          io.cloudslang.base.remote_file_transfer.remote_secure_copy:
            - source_path: '${filename}'
            - destination_host: '${host}'
            - destination_path: /tmp
            - destination_username: '${username}'
            - destination_password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      extract_filename:
        x: 103
        y: 159
      get_file:
        x: 291
        y: 152
      remote_secure_copy:
        x: 468
        y: 154
        navigate:
          5be3fd07-717d-a571-aa29-cb6e3c5d200b:
            targetId: dbf175aa-00ac-41b6-f3e4-a9aa6c11064f
            port: SUCCESS
    results:
      SUCCESS:
        dbf175aa-00ac-41b6-f3e4-a9aa6c11064f:
          x: 652
          y: 155
