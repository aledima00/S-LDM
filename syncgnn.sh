echo "Updating gnn submodule..."
git submodule sync
git submodule update --remote gnn
cd gnn
. install_dependencies.sh
cd ..