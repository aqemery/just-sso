_:
    @just -l -u

sso profile:
    #!/usr/bin/env bash
    aws sso login --profile {{profile}}
    aws sts get-caller-identity --profile {{profile}}
    just set_default_profile {{profile}}

set_default_profile profile:
    #!/usr/bin/env python3
    import subprocess
    import boto3
    session = boto3.Session(profile_name='{{profile}}')
    creds = session.get_credentials()
    print(creds.get_frozen_credentials())
    sp = subprocess.Popen(['aws configure'], shell=True, stdin=subprocess.PIPE)
    data = f'''{creds.access_key}
    {creds.secret_key}
    us-east-1
    json

    '''
    sp.communicate(input=data.encode())
    subprocess.run(['aws', 'configure', 'set', 'aws_session_token', creds.token])
