#!/bin/bash

apt-get update 2>/dev/null | grep packages | cut -d '.' -f 1
apt-get install -y ruby-full ruby-bundler build-essential
