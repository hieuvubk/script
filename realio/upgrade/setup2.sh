#!/bin/bash

./realio-networkd tx multistaking create-validator ./validator4.json --from validator4 --keyring-backend test --home ~/.realio-network/validator3 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000
./realio-networkd tx multistaking create-validator ./validator5.json --from validator5 --keyring-backend test --home ~/.realio-network/validator3 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000
sleep 10
./realio-networkd tx multistaking delegate realiovaloper13x89uzusu8w5wcm8p0ynat9wnnakasfs84ngvt 111arst --from validator5 --keyring-backend test --home ~/.realio-network/validator3 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000
# ./realio-networkd tx multistaking delegate realiovaloper13x89uzusu8w5wcm8p0ynat9wnnakasfs84ngvt 11arst --from validator4 --keyring-backend test --home ~/.realio-network/validator3 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000
# ./realio-networkd tx multistaking delegate realiovaloper13x89uzusu8w5wcm8p0ynat9wnnakasfs84ngvt 200000000000000000000arst --from validator2 --keyring-backend test --home ~/.realio-network/validator2 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000
./realio-networkd tx multistaking delegate realiovaloper13x89uzusu8w5wcm8p0ynat9wnnakasfs84ngvt 1234567890000000001arst --from validator4 --keyring-backend test --home ~/.realio-network/validator3 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000
sleep 10
./realio-networkd tx multistaking unbond realiovaloper13x89uzusu8w5wcm8p0ynat9wnnakasfs84ngvt 1000000000000000000arst --from validator5 --keyring-backend test --home ~/.realio-network/validator5 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000
# ./realio-networkd tx multistaking unbond realiovaloper13x89uzusu8w5wcm8p0ynat9wnnakasfs84ngvt 20000000000000000000arst --from validator2 --keyring-backend test --home ~/.realio-network/validator2 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000
# ./realio-networkd tx multistaking unbond realiovaloper13x89uzusu8w5wcm8p0ynat9wnnakasfs84ngvt 30000000000000000000arst --from validator3 --keyring-backend test --home ~/.realio-network/validator3 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000
