#!/bin/bash
sed -i "s/\(tag:[[:space:]]*\"v\)[0-9]\+\"/\1${BUILD_NUMBER}\"/" ./mavenwebapp/values.yaml
