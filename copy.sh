#!/bin/bash

USER=postgres
DATABASE=postgres
HOST=localhost

psql -U "$USER" -h "$HOST" "$DATABASE" < copy_commands.txt