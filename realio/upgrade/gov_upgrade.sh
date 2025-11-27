#!/bin/bash

./realio-networkd tx gov submit-proposal ./upgrade.json --from validator1 --fees 1000000ario --gas 2263340  --keyring-backend=test --home=$HOME/.realio-network/validator1 -y

sleep 7

./realio-networkd tx gov vote 1 yes  --from validator1 --keyring-backend test --home ~/.realio-network/validator1 --chain-id realionetwork_3301-1 -y --fees 13000ario
./realio-networkd tx gov vote 1 yes  --from validator2 --keyring-backend test --home ~/.realio-network/validator2 --chain-id realionetwork_3301-1 -y --fees 913000ario
./realio-networkd tx gov vote 1 yes  --from validator3 --keyring-backend test --home ~/.realio-network/validator3 --chain-id realionetwork_3301-1 -y --fees 73000ario
