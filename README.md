# push-cache effect

## Overview

Repository shows how to push some paths to a specified cache with hercules effect.
We use a flake-parts module called `push-cache-effect`. For option definitions check source at [TODOLINK](https://github.com/zmrocze/hercules-ci-effects/blob/3fa860ba2b1fe6a2c5e45684f015dc441b9cc202/effects/push-cache/default.nix).

## Secrets

You need to configure HerculesCI agent providing it with a secret, so that it can access the cache. Check module option docs in hercules-ci-effects ([link1](https://github.com/zmrocze/hercules-ci-effects/blob/3fa860ba2b1fe6a2c5e45684f015dc441b9cc202/effects/push-cache/default.nix), [link2]) for secret's format. For mlabs ask devops to do it.

Example `secret.json`:

```json
{
  "attic-test-token": {
    "condition" : {
        "and" : [            
        ]
    },
    "data": {
      "name": "cache-name",
      "endpoint": "https://cache.staging.mlabs.city/",
      "token": "my_push_token"
    },
    "kind": "Secret"
  }, 
}
```