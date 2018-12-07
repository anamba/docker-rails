#!/bin/bash

su app -l -c 'cd ~/myapp && bundle install --jobs 8'
echo "bundler done"
