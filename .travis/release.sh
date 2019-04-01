#!/bin/bash -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ -z "$1" ]]; then
  echo "ERROR: Version is undefined"
  exit 1
fi
if [[ -z "${SONATYPE_USERNAME}" ]]; then
  echo "ERROR: SONATYPE_USERNAME is undefined"
  exit 1
fi
if [[ -z "${SONATYPE_PASSWORD}" ]]; then
  echo "ERROR: SONATYPE_PASSWORD is undefined"
  exit 1
fi
if [[ -z "${GPG_KEYNAME}" ]]; then
  echo "ERROR: GPG_KEYNAME is undefined"
  exit 1
fi
if [[ -z "${GPG_PASSPHRASE}" ]]; then
  echo "ERROR: GPG_PASSPHRASE is undefined"
  exit 1
fi

mvn versions:set -DnewVersion=${TRAVIS_TAG} -DgenerateBackupPoms=false
mvn clean deploy -B -P release --settings ${DIR}/settings.xml