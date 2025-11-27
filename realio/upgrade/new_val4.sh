#!/bin/bash

set -e

rm -rf ~/.realio-network/validator4

# node 4
mkdir $HOME/.realio-network/validator4

./realio-networkd init validator4 --chain-id realionetwork_3301-1 --home=$HOME/.realio-network/validator4

# ./realio-networkd keys add validator4 --keyring-backend=test --home=$HOME/.realio-network/validator4
# echo $(cat ../../keys/mnemonic4)| ./realio-networkd keys add validator4 --recover --keyring-backend=test --home=$HOME/.realio-network/validator4
#osmo1qvuhm5m644660nd8377d6l7yz9e9hhm93hgk85

VALIDATOR4_APP_TOML=$HOME/.realio-network/validator4/config/app.toml

# # validator4
sed -i -E 's|tcp://localhost:1317|tcp://localhost:1313|g' $VALIDATOR4_APP_TOML
sed -i -E 's|localhost:9090|localhost:9082|g' $VALIDATOR4_APP_TOML
sed -i -E 's|enable = false|enable = true|g' $VALIDATOR4_APP_TOML
sed -i -E 's|localhost:9091|localhost:9083|g' $VALIDATOR4_APP_TOML
sed -i -E 's|tcp://0.0.0.0:10337|tcp://0.0.0.0:10377|g' $VALIDATOR4_APP_TOML
sed -i -E 's|127.0.0.1:8545|127.0.0.1:8515|g' $VALIDATOR4_APP_TOML


VALIDATOR4_CONFIG=$HOME/.realio-network/validator4/config/config.toml

# # validator4
sed -i -E 's|tcp://127.0.0.1:26658|tcp://127.0.0.1:26646|g' $VALIDATOR4_CONFIG
sed -i -E 's|tcp://127.0.0.1:26657|tcp://127.0.0.1:26645|g' $VALIDATOR4_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26644|g' $VALIDATOR4_CONFIG
sed -i -E 's|allow_duplicate_ip = false|allow_duplicate_ip = true|g' $VALIDATOR4_CONFIG
sed -i -E 's|prometheus = false|prometheus = true|g' $VALIDATOR4_CONFIG
sed -i -E 's|prometheus_listen_addr = ":26660"|prometheus_listen_addr = ":26600"|g' $VALIDATOR4_CONFIG

cp $HOME/.realio-network/validator1/config/genesis.json $HOME/.realio-network/validator4/config/genesis.json

# copy tendermint node id of validator1 to persistent peers of validator2-3
node1=$(./realio-networkd tendermint show-node-id --home=$HOME/.realio-network/validator1)
node2=$(./realio-networkd tendermint show-node-id --home=$HOME/.realio-network/validator2)
node3=$(./realio-networkd tendermint show-node-id --home=$HOME/.realio-network/validator3)

sed -i -E "s|persistent_peers = \"\"|persistent_peers = \"$node1@localhost:26656,$node2@localhost:26653,$node3@localhost:26650\"|g" $HOME/.realio-network/validator4/config/config.toml

# ./realio-networkd keys show validator4 -a --keyring-backend=test --home=$HOME/.realio-network/validator4

# screen -S osmo4 -t osmo4 -d -m 
./realio-networkd start --home=$HOME/.realio-network/validator4

# sleep 7
# # osmo1qvuhm5m644660nd8377d6l7yz9e9hhm93hgk85

# ./realio-networkd tx staking create-validator \
#   --amount=1000000000000000000000stake \
#   --pubkey=$(./realio-networkd tendermint show-validator --home=$HOME/.realio-network/validator4) \
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
#   --home=$HOME/.realio-network/validator4 \
#   --fees=1250stake \
#   -y