#!/bin/bash
export $(grep -v '^#' .env | xargs)
printenv | grep TF_VAR_