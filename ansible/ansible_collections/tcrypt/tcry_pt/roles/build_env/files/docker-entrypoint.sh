#!/bin/bash

eval "$(ssh-agent -s)"

exec "$@"
