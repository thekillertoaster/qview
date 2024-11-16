#!/bin/bash

# echo current working dir
echo "Current working directory: $(pwd)"

# does our virtual environment exist?
NEW_VENV=false
if [ ! -d ".venv" ]; then
    # create a virtual environment
    python -m venv .venv

    # set the flag to true
    NEW_VENV=true
fi

source .venv/Scripts/activate

# get the python executable path
VENV_PYTHON=$(python -c "import sys; print(sys.prefix)")

# does it end with .venv?
if [[ $VENV_PYTHON != *".venv"* ]]; then
    echo "Virtual environment is not activated"
    exit 1
fi

# bootstrap the virtual environment if it's new
if [ "$NEW_VENV" = true ]; then
    # upgrade pip
    pip install --upgrade pip

    # install the project dependencies
    pip install build setuptools --upgrade
fi

echo "Virtual environment is activated"

# build the project
python -m build

# install the project (file with .whl extension)
pip install dist/*.whl --force-reinstall