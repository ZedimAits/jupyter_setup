# jupyter_setup
setup script for Jupyter notebooks: creates a local uv-managed Python venv, installs requirements and registers an IPython kernel

# Requirements
- you need to have [UV](https://docs.astral.sh/uv/) installed

# Usage:
- put required libaries in `requirements.txt`
- set python version in second line in `setup.sh`
- run `setup.sh` (don't forget `chmod +x setup.sh`)
- Select local `.venv` in your jupyter notebook
