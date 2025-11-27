#!/bin/bash

set -e

rm -rf ~/.realio-network/validator5

# node 4
mkdir $HOME/.realio-network/validator5

./realio-networkd init validator5 --chain-id realionetwork_3301-1 --home=$HOME/.realio-network/validator5

# ./realio-networkd keys add validator5 --keyring-backend=test --home=$HOME/.realio-network/validator5
echo $(cat ../../keys/mnemonic5)| ./realio-networkd keys add validator5 --recover --keyring-backend=test --home=$HOME/.realio-network/validator5
#osmo1qvuhm5m644660nd8377d6l7yz9e9hhm93hgk85

VALIDATOR5_APP_TOML=$HOME/.realio-network/validator5/config/app.toml

# # validator5
sed -i -E 's|tcp://localhost:1317|tcp://localhost:1313|g' $VALIDATOR5_APP_TOML
sed -i -E 's|localhost:9090|localhost:9080|g' $VALIDATOR5_APP_TOML
sed -i -E 's|enable = false|enable = true|g' $VALIDATOR5_APP_TOML
sed -i -E 's|localhost:9091|localhost:9081|g' $VALIDATOR5_APP_TOML
sed -i -E 's|tcp://0.0.0.0:10337|tcp://0.0.0.0:10377|g' $VALIDATOR5_APP_TOML
sed -i -E 's|127.0.0.1:8545|127.0.0.1:8514|g' $VALIDATOR5_APP_TOML


VALIDATOR5_CONFIG=$HOME/.realio-network/validator5/config/config.toml

# # validator5
sed -i -E 's|tcp://127.0.0.1:26658|tcp://127.0.0.1:26643|g' $VALIDATOR5_CONFIG
sed -i -E 's|tcp://127.0.0.1:26657|tcp://127.0.0.1:26642|g' $VALIDATOR5_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26641|g' $VALIDATOR5_CONFIG
sed -i -E 's|allow_duplicate_ip = false|allow_duplicate_ip = true|g' $VALIDATOR5_CONFIG
sed -i -E 's|prometheus = false|prometheus = true|g' $VALIDATOR5_CONFIG
sed -i -E 's|prometheus_listen_addr = ":26659"|prometheus_listen_addr = ":26600"|g' $VALIDATOR5_CONFIG

cp $HOME/.realio-network/validator1/config/genesis.json $HOME/.realio-network/validator5/config/genesis.json

# copy tendermint node id of validator1 to persistent peers of validator2-3
node1=$(./realio-networkd tendermint show-node-id --home=$HOME/.realio-network/validator1)
node2=$(./realio-networkd tendermint show-node-id --home=$HOME/.realio-network/validator2)
node3=$(./realio-networkd tendermint show-node-id --home=$HOME/.realio-network/validator3)

sed -i -E "s|persistent_peers = \"\"|persistent_peers = \"$node1@localhost:26656,$node2@localhost:26653,$node3@localhost:26650\"|g" $HOME/.realio-network/validator5/config/config.toml

# ./realio-networkd keys show validator5 -a --keyring-backend=test --home=$HOME/.realio-network/validator5

# screen -S osmo4 -t osmo4 -d -m 
./realio-networkd start --home=$HOME/.realio-network/validator5

# sleep 7
# # osmo1qvuhm5m644660nd8377d6l7yz9e9hhm93hgk85

# ./realio-networkd tx staking create-validator \
#   --amount=1000000000000000000000stake \
#   --pubkey=$(./realio-networkd tendermint show-validator --home=$HOME/.realio-network/validator5) \
#   --moniker=MONIKER-YAZ \
#   --chain-id=testing-1 \
#   --commission-rate=0.05 \
#   --commission-max-rate=0.10 \
#   --commission-max-change-rate=0.01 \
#   --min-self-delegation=1 \
#   --from=osmo1qvuhm5m644660nd8377d6l7yz9e9hhm93hgk85 \
#   --identity="" \
#   --website="" \
#   --details="" \
#   --gas=500000 \
#   --keyring-backend=test \
#   --home=$HOME/.realio-network/validator5 \
#   --fees=1250stake \
#   -y