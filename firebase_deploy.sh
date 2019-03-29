#!/usr/bin/env bash

npm run build;

echo "Deploying Nifty Football Builder"
firebase use nifty-football-builder;
firebase deploy;
