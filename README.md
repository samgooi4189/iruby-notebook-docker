# iruby-notebook-docker
This is iruby notebook with docker, so you can start sciruby without much configuration

## Requirements
* docker

## How to run
* docker run -p 8888:8888 -v $(pwd)/workspace:/home/sciruby/workspace -it rubytues/iruby /bin/bash
* jupyter notebook --NotebookApp.token='' --ip=0.0.0.0 --port=8888 --no-browser

## Note
* The workspace folder in the repo is mounted to the docker container, so anything that you do in the container will be saved to that folder and you still able to see it after the container being shut down.
* Make sure the folder is correctly mounted by creating a new file in jupyter notebook, then see if the file exist in the host folder.

Happy learning!
