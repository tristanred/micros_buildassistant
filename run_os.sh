#!/bin/bash

cd /builder

git clone https://github.com/tristanred/micros.git

cd micros

make resetdisk

make run