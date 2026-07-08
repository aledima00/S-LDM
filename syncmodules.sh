#!/usr/bin/env bash
echo "Syncing submodules..."
git submodule sync
git submodule update --init --recursive gnn dataset-generator

echo "Installing gnn dependencies..."
cd gnn && . install_dependencies.sh && cd ..

echo "Installing dataset-generator dependencies..."
cd dataset-generator && . install_dependencies.sh && cd ..