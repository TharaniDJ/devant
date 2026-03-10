#!/bin/bash

# Test webhook payload simulating a merged PR
































  }'    }      "html_url": "https://github.com/TharaniDJ/devant"      "full_name": "TharaniDJ/devant",      "name": "devant",    "repository": {    },      "changed_files": 3      "deletions": 10,      "additions": 50,      },        "ref": "feature-branch"      "head": {      },        "ref": "main"      "base": {      },        "html_url": "https://github.com/testuser"        "login": "testuser",      "user": {      "html_url": "https://github.com/TharaniDJ/devant/pull/999",      "body": "This is a test PR to verify the integration works locally",      "merged": true,      "state": "closed",      "title": "Test PR - Local Simulation",      "number": 999,    "pull_request": {    "action": "closed",  -d '{  -H "Content-Type: application/json" \curl -X POST http://localhost:8090/github/webhook \
