#!/usr/bin/env bash

puppet apply --modulepath=/src/entrypoint/run/modules /src/entrypoint/run/run.pp

/usr/bin/supervisord
