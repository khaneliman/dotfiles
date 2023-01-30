#!/bin/bash

docker rmi $(docker images --quiet --filter "dangling=true")

echo Finished
echo if an error shows above, no dangling images were found to delete
