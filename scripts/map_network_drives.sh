#!/bin/bash

declare -A drive_mapping

drive_mapping['\\pstore\personal\humphrig']=p
drive_mapping['\\commonstore\RubyJCT']=y

for drive_path in "${!drive_mapping[@]}"; do
    mapped_path="/mnt/${drive_mapping[$drive_path]}"

    mkdir -p "$mapped_path"
    mount -t drvfs "$drive_path" "$mapped_path"
done
