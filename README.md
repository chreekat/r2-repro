## To repro

#### 1. Install a Haskell toolchain

Run the following and accept all defaults:

```
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

#### 2. Put your credentials somewhere

I created a script like

```
#!/usr/bin/env bash

# Script name: DELETEME-run-with-creds.sh

set -Eeuo pipefail

export AWS_ACCESS_KEY_ID=MyKeyId
export AWS_SECRET_ACCESS_KEY=MySecretKey
export AWS_S3_ENDPOINT=MyS2Endpoint

stack --stack-yaml stack.1.6.1.yaml run -- MyBucketName
```

But you can also use standard ~/.aws config stuff.

#### 3. Run the app

Note the app takes a bucket name as a parameter, as demonstrated in the script
example above.

```
./DELETEME-run-with-creds.sh
```
