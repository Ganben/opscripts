#!/bin/bash

# mxnet
pip3 install mxnet

# torch

git clone https://github.com/torch/distro.git ~/torch --recursive
cd ~/torch; bash install-deps;
./install.sh

# MSParS (dataset)
# https://github.com/msra-nlc/MSParS

# mission
# 用LSTM、GRU来训练字符级的语言模型，计算困惑度, text generation; use pytorch, 

