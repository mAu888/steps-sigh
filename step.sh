#!/bin/bash

function print_and_do_command {
  echo "-> $ $@"
  $@
}

function print_and_do_command_exit_on_error {
  print_and_do_command $@
  if [ $? -ne 0 ]; then
    echo " [!] Failed!"
    exit 1
  fi
}

function verify_variable_set {
  if [ -z "$1" ]; then
    echo " [!] Missing $2!"
    exit 1
  fi
}

# Some helpful stuff
THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check for sigh
gem list sigh -i >/dev/null
if [ $? -ne 0 ]; then
  print_and_do_command_exit_on_error gem install --no-ri --no-rdoc sigh
fi

# Get a temporary directory
PROFILE_DIRECTORY=$(mktemp -d)

# Construct command arguments
COMMAND_OPTS="--skip_install -z -o ${PROFILE_DIRECTORY}"

if [ "${profile_type}" == "adhoc" ]; then
  COMMAND_OPTS="${COMMAND_OPTS} --adhoc --force"
elif [ "${profile_type}" == "development" ]; then
  COMMAND_OPTS="${COMMAND_OPTS} --development"
elif [ "${profile_type}" != "appstore" ]; then
  echo " [!] Invalid profile type '${profile_type}'"
  exit 1
fi

# Required parameters
verify_variable_set "${bundle_identifier}" "application bundle identifier"
verify_variable_set "${certificate_id}" "certificate identifier"

COMMAND_OPTS="${COMMAND_OPTS} -a ${bundle_identifier} -i ${certificate_id}"

# Optional parameters
if [ ! -z "${team_id}" ]; then
  COMMAND_OPTS="${COMMAND_OPTS} -b ${team_id}"
fi

print_and_do_command_exit_on_error sigh ${COMMAND_OPTS}

# Collect provisioning profiles
EXPORT_PROFILES_PATHS=$(swift "${THIS_SCRIPT_DIR}/collect_profiles.swift" "${PROFILE_DIRECTORY}")

# Export the provisioning profiles
envman add --key provisioning_profile_paths --value ${EXPORT_PROFILES_PATHS}
