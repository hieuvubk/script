#!/bin/bash
set -xeu

# always returns true so set -e doesn't exit if it is not running.
killall realio-networkd || true
rm -rf $HOME/.realio-network/

# make four mesh directories
mkdir $HOME/.realio-network
mkdir $HOME/.realio-network/validator1
mkdir $HOME/.realio-network/validator2
mkdir $HOME/.realio-network/validator3

# init all three validators
./realio-networkd init  --chain-id realionetwork_3301-1 validator1 --home=$HOME/.realio-network/validator1
./realio-networkd init  --chain-id realionetwork_3301-1 validator2 --home=$HOME/.realio-network/validator2
./realio-networkd init  --chain-id realionetwork_3301-1 validator3 --home=$HOME/.realio-network/validator3

# create keys for all three validators
# ./realio-networkd keys add validator1 --keyring-backend=test --home=$HOME/.realio-network/validator1/Users/donglieu/script/keys/mnemonic1
m1="salmon fashion film curve cause palace ancient honey cactus donkey inhale awful resource run junior evil impact border off jacket behave rifle agree eagle"
m2="method kiss layer inherit grain define lecture document corn giraffe galaxy salute ensure mixture release punch duty ridge comfort road cross short review trend"
m3="original attract brass stumble poverty mobile route soup door blanket engage differ give arrest faint stadium impose outdoor shine wrist lion envelope regular pluck"
m4="improve fun aim fringe machine shed repair olympic copper buddy road used trial liquid energy diamond orange lock time exact away change icon spike"
m5="ready smart squirrel name hurry project humor illegal nurse chicken small course party vacant define rack promote major useless symptom debate example asset hungry"

echo $m1| ./realio-networkd keys add validator1 --keyring-backend test --recover --home=$HOME/.realio-network/validator1
# ./realio-networkd keys add validator2 --keyring-backend=test --home=$HOME/.realio-network/validator2
echo $m2| ./realio-networkd keys add validator2 --keyring-backend test  --recover --home=$HOME/.realio-network/validator2
# ./realio-networkd keys add validator3 --keyring-backend=test --home=$HOME/.realio-network/validator3
echo $m3| ./realio-networkd keys add validator3 --keyring-backend test  --recover --home=$HOME/.realio-network/validator3
echo $m4| ./realio-networkd keys add validator4 --keyring-backend test  --recover --home=$HOME/.realio-network/validator3
echo $m5| ./realio-networkd keys add validator5 --keyring-backend test  --recover --home=$HOME/.realio-network/validator3



update_test_genesis () {
    # EX: update_test_genesis '.consensus_params["block"]["max_gas"]="100000000"'
    cat $HOME/.realio-network/validator1/config/genesis.json | jq "$1" > tmp.json && mv tmp.json $HOME/.realio-network/validator1/config/genesis.json
}

update_test_genesis '.app_state["staking"]["params"]["bond_denom"] = "ario"'
update_test_genesis '.app_state["slashing"]["params"]["signed_blocks_window"] = "10"'
update_test_genesis '.app_state["staking"]["params"]["unbonding_time"] = "300s"'
update_test_genesis '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="ario"'
update_test_genesis '.app_state["gov"]["params"]["min_deposit"][0]["denom"]="ario"'
update_test_genesis '.app_state["gov"]["params"]["expedited_min_deposit"][0]["denom"]="ario"'
update_test_genesis '.app_state["evm"]["params"]["evm_denom"] = "ario"'
update_test_genesis '.app_state["evm"]["params"]["active_static_precompiles"][0] = "0x0000000000000000000000000000000000000801"'
update_test_genesis '.app_state["evm"]["params"]["active_static_precompiles"][1] = "0x0000000000000000000000000000000000000900"'
update_test_genesis '.app_state["mint"]["params"]["mint_denom"]="ario"'
update_test_genesis '.app_state["multistaking"]["multi_staking_coin_info"]=[{"denom": "ario", "bond_weight": "1.000000000000000000"}, {"denom": "arst", "bond_weight": "1.000000000000000000"}]'
update_test_genesis '.app_state["multistaking"]["staking_genesis_state"]["params"]["unbonding_time"] = "300s"'
update_test_genesis '.app_state["bank"]["denom_metadata"]=[{"description":"The native staking token for realio-networkd.","denom_units":[{"denom":"ario","exponent":0,"aliases":["attorio"]},{"denom":"rio","exponent":18,"aliases":[]}],"base":"ario","display":"rio","name":"Rio Token","symbol":"RIO","uri":"","uri_hash":""}]'
update_test_genesis '.consensus.params.block.max_gas="10000000"'


# create validator node with tokens to transfer to the three other nodes
./realio-networkd genesis add-genesis-account $(./realio-networkd keys show validator1 -a --keyring-backend=test --home=$HOME/.realio-network/validator1) 1000000000stake,10000000000000000000000ario,10000000000000000000000arst --home=$HOME/.realio-network/validator1 
./realio-networkd genesis add-genesis-account $(./realio-networkd keys show validator2 -a --keyring-backend=test --home=$HOME/.realio-network/validator2) 1000000000stake,10000000000000000000000ario,10000000000000000000000arst --home=$HOME/.realio-network/validator1 
./realio-networkd genesis add-genesis-account $(./realio-networkd keys show validator3 -a --keyring-backend=test --home=$HOME/.realio-network/validator3) 1000000000stake,10000000000000000000000ario,10000000000000000000000arst --home=$HOME/.realio-network/validator1
./realio-networkd genesis add-genesis-account $(./realio-networkd keys show validator4 -a --keyring-backend=test --home=$HOME/.realio-network/validator3) 1000000000stake,10000000000000000000000ario,10000000000000000000000arst --home=$HOME/.realio-network/validator1 
./realio-networkd genesis add-genesis-account $(./realio-networkd keys show validator5 -a --keyring-backend=test --home=$HOME/.realio-network/validator3) 1000000000stake,10000000000000000000000ario,10000000000000000000000arst --home=$HOME/.realio-network/validator1 

./realio-networkd genesis add-genesis-account $(./realio-networkd keys show validator1 -a --keyring-backend=test --home=$HOME/.realio-network/validator1) 1000000000stake,10000000000000000000000ario,10000000000000000000000arst --home=$HOME/.realio-network/validator2 
./realio-networkd genesis add-genesis-account $(./realio-networkd keys show validator2 -a --keyring-backend=test --home=$HOME/.realio-network/validator2) 1000000000stake,10000000000000000000000ario,10000000000000000000000arst --home=$HOME/.realio-network/validator2 
./realio-networkd genesis add-genesis-account $(./realio-networkd keys show validator3 -a --keyring-backend=test --home=$HOME/.realio-network/validator3) 1000000000stake,10000000000000000000000ario,10000000000000000000000arst --home=$HOME/.realio-network/validator2
./realio-networkd genesis add-genesis-account $(./realio-networkd keys show validator4 -a --keyring-backend=test --home=$HOME/.realio-network/validator3) 1000000000stake,10000000000000000000000ario,10000000000000000000000arst --home=$HOME/.realio-network/validator2 
./realio-networkd genesis add-genesis-account $(./realio-networkd keys show validator5 -a --keyring-backend=test --home=$HOME/.realio-network/validator3) 1000000000stake,10000000000000000000000ario,10000000000000000000000arst --home=$HOME/.realio-network/validator2 

./realio-networkd genesis add-genesis-account $(./realio-networkd keys show validator1 -a --keyring-backend=test --home=$HOME/.realio-network/validator1) 1000000000stake,10000000000000000000000ario,10000000000000000000000arst --home=$HOME/.realio-network/validator3 
./realio-networkd genesis add-genesis-account $(./realio-networkd keys show validator2 -a --keyring-backend=test --home=$HOME/.realio-network/validator2) 1000000000stake,10000000000000000000000ario,10000000000000000000000arst --home=$HOME/.realio-network/validator3 
./realio-networkd genesis add-genesis-account $(./realio-networkd keys show validator3 -a --keyring-backend=test --home=$HOME/.realio-network/validator3) 1000000000stake,10000000000000000000000ario,10000000000000000000000arst --home=$HOME/.realio-network/validator3
./realio-networkd genesis add-genesis-account $(./realio-networkd keys show validator4 -a --keyring-backend=test --home=$HOME/.realio-network/validator3) 1000000000stake,10000000000000000000000ario,10000000000000000000000arst --home=$HOME/.realio-network/validator3 
./realio-networkd genesis add-genesis-account $(./realio-networkd keys show validator5 -a --keyring-backend=test --home=$HOME/.realio-network/validator3) 1000000000stake,10000000000000000000000ario,10000000000000000000000arst --home=$HOME/.realio-network/validator3 

./realio-networkd genesis gentx validator1 1000000000000000000000ario --keyring-backend=test --home=$HOME/.realio-network/validator1  --chain-id realionetwork_3301-1
./realio-networkd genesis gentx validator2 1000000000000000000000ario --keyring-backend=test --home=$HOME/.realio-network/validator2  --chain-id realionetwork_3301-1
./realio-networkd genesis gentx validator3 1000000000000000000000ario --keyring-backend=test --home=$HOME/.realio-network/validator3  --chain-id realionetwork_3301-1


cp $HOME/.realio-network/validator2/config/gentx/*.json $HOME/.realio-network/validator1/config/gentx/
cp $HOME/.realio-network/validator3/config/gentx/*.json $HOME/.realio-network/validator1/config/gentx/
./realio-networkd genesis collect-gentxs --home=$HOME/.realio-network/validator1 

# change app.toml values
VALIDATOR1_APP_TOML=$HOME/.realio-network/validator1/config/app.toml
VALIDATOR2_APP_TOML=$HOME/.realio-network/validator2/config/app.toml
VALIDATOR3_APP_TOML=$HOME/.realio-network/validator3/config/app.toml

# validator1
sed -i -E 's|0.0.0.0:9090|0.0.0.0:9050|g' $VALIDATOR1_APP_TOML
sed -i -E 's|enable = false|enable = true|g' $VALIDATOR1_APP_TOML
# sed -i -E 's|127.0.0.1:9090|127.0.0.1:9050|g' $VALIDATOR1_APP_TOML

# validator2
sed -i -E 's|0.0.0.0:1317|0.0.0.0:1316|g' $VALIDATOR2_APP_TOML
sed -i -E 's|0.0.0.0:9090|0.0.0.0:9088|g' $VALIDATOR2_APP_TOML
sed -i -E 's|enable = false|enable = true|g' $VALIDATOR2_APP_TOML
sed -i -E 's|0.0.0.0:9091|0.0.0.0:9089|g' $VALIDATOR2_APP_TOML
# sed -i -E 's|localhost:9091|localhost:9089|g' $VALIDATOR2_APP_TOML
sed -i -E 's|127.0.0.1:8545|127.0.0.1:8535|g' $VALIDATOR2_APP_TOML

# validator3
sed -i -E 's|0.0.0.0:1317|0.0.0.0:1315|g' $VALIDATOR3_APP_TOML
sed -i -E 's|0.0.0.0:9090|0.0.0.0:9086|g' $VALIDATOR3_APP_TOML
sed -i -E 's|enable = false|enable = true|g' $VALIDATOR3_APP_TOML
sed -i -E 's|0.0.0.0:9091|0.0.0.0:9087|g' $VALIDATOR3_APP_TOML
# sed -i -E 's|localhost:9091|localhost:9087|g' $VALIDATOR3_APP_TOML
sed -i -E 's|127.0.0.1:8545|127.0.0.1:8525|g' $VALIDATOR3_APP_TOML

# change config.toml values
VALIDATOR1_CONFIG=$HOME/.realio-network/validator1/config/config.toml
VALIDATOR2_CONFIG=$HOME/.realio-network/validator2/config/config.toml
VALIDATOR3_CONFIG=$HOME/.realio-network/validator3/config/config.toml


# validator1
sed -i -E 's|allow_duplicate_ip = false|allow_duplicate_ip = true|g' $VALIDATOR1_CONFIG
sed -i -E 's|prometheus = false|prometheus = true|g' $VALIDATOR1_CONFIG


# validator2
sed -i -E 's|tcp://127.0.0.1:26658|tcp://127.0.0.1:26655|g' $VALIDATOR2_CONFIG
sed -i -E 's|tcp://127.0.0.1:26657|tcp://127.0.0.1:26654|g' $VALIDATOR2_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26653|g' $VALIDATOR2_CONFIG
sed -i -E 's|allow_duplicate_ip = false|allow_duplicate_ip = true|g' $VALIDATOR2_CONFIG
sed -i -E 's|prometheus = false|prometheus = true|g' $VALIDATOR2_CONFIG
sed -i -E 's|prometheus_listen_addr = ":26660"|prometheus_listen_addr = ":26630"|g' $VALIDATOR2_CONFIG

# validator3
sed -i -E 's|tcp://127.0.0.1:26658|tcp://127.0.0.1:26652|g' $VALIDATOR3_CONFIG
sed -i -E 's|tcp://127.0.0.1:26657|tcp://127.0.0.1:26651|g' $VALIDATOR3_CONFIG
sed -i -E 's|tcp://0.0.0.0:26656|tcp://0.0.0.0:26650|g' $VALIDATOR3_CONFIG
sed -i -E 's|allow_duplicate_ip = false|allow_duplicate_ip = true|g' $VALIDATOR3_CONFIG
sed -i -E 's|prometheus = false|prometheus = true|g' $VALIDATOR3_CONFIG
sed -i -E 's|prometheus_listen_addr = ":26660"|prometheus_listen_addr = ":26620"|g' $VALIDATOR3_CONFIG


update_test_genesis '.app_state["gov"]["voting_params"]["voting_period"] = "15s"'
update_test_genesis '.app_state["gov"]["params"]["voting_period"] = "15s"'

update_test_genesis '.app_state["feemarket"]["params"]["base_fee"] = "0"'

# copy validator1 genesis file to validator2-3
cp $HOME/.realio-network/validator1/config/genesis.json $HOME/.realio-network/validator2/config/genesis.json
cp $HOME/.realio-network/validator1/config/genesis.json $HOME/.realio-network/validator3/config/genesis.json

node1=$(./realio-networkd tendermint show-node-id --home=$HOME/.realio-network/validator1)
node2=$(./realio-networkd tendermint show-node-id --home=$HOME/.realio-network/validator2)
node3=$(./realio-networkd tendermint show-node-id --home=$HOME/.realio-network/validator3)
sed -i -E "s|persistent_peers = \"\"|persistent_peers = \"$node1@localhost:26656,$node2@localhost:26656,$node3@localhost:26656\"|g" $HOME/.realio-network/validator1/config/config.toml
sed -i -E "s|persistent_peers = \"\"|persistent_peers = \"$node1@localhost:26656,$node2@localhost:26656,$node3@localhost:26656\"|g" $HOME/.realio-network/validator2/config/config.toml
sed -i -E "s|persistent_peers = \"\"|persistent_peers = \"$node1@localhost:26656,$node2@localhost:26656,$node3@localhost:26656\"|g" $HOME/.realio-network/validator3/config/config.toml


# # start all three validators/
# ./realio-networkd start --home=$HOME/.realio-network/validator1
screen -S realio-networkd1 -t realio-networkd1 -d -m ./realio-networkd start --home=$HOME/.realio-network/validator1
screen -S realio-networkd2 -t realio-networkd2 -d -m ./realio-networkd start --home=$HOME/.realio-network/validator2
screen -S realio-networkd3 -t realio-networkd3 -d -m ./realio-networkd start --home=$HOME/.realio-network/validator3
# ./realio-networkd start --home=$HOME/.realio-network/validator3

# sleep 7
# # ./realio-networkd tx gov submit-legacy-proposal /Users/donglieu/script/realio/upgrade/upgrade.json
# # ./realio-networkd tx bank send $(./realio-networkd keys show validator1 -a --keyring-backend=test --home=$HOME/.realio-network/validator1) $(./realio-networkd keys show validator2 -a --keyring-backend=test --home=$HOME/.realio-network/validator2) 100000stake --keyring-backend=test  --chain-id realionetwork_3301-1 -y --home=$HOME/.realio-network/validator1 --fees 10stake

# ./realio-networkd tx gov submit-proposal ./gov1.json --from validator1 --fees 1000000ario --gas 2263340  --keyring-backend=test --home=$HOME/.realio-network/validator1 -y

# sleep 7

# ./realio-networkd tx gov vote 1 yes  --from validator1 --keyring-backend test --home ~/.realio-network/validator1 --chain-id realionetwork_3301-1 -y --fees 13000ario
# ./realio-networkd tx gov vote 1 yes  --from validator2 --keyring-backend test --home ~/.realio-network/validator2 --chain-id realionetwork_3301-1 -y --fees 3000ario
# ./realio-networkd tx gov vote 1 yes  --from validator3 --keyring-backend test --home ~/.realio-network/validator3 --chain-id realionetwork_3301-1 -y --fees 13000ario

# sleep 7 

# ./realio-networkd tx bank send realio1jyrr9ga485mzdw6u7w7vcvcmhz8h6zq8w4vxzu realio1j7qsamh9t7mynehxz2svfrpqglyeexty762dyr 89999999999999909995ario  --from validator1 --keyring-backend test --home ~/.realio-network/validator1 --chain-id realionetwork_3301-1 -y --fees 100ario


# wating deploy contract

# sleep 7

# ./realio-networkd tx gov submit-proposal ./gov3.json --from validator1 --fees 1000000ario --gas 2263340  --keyring-backend=test --home=$HOME/.realio-network/validator1 -y

# sleep 7

# ./realio-networkd tx gov vote 1 yes  --from validator1 --keyring-backend test --home ~/.realio-network/validator1 --chain-id realionetwork_3301-1 -y --fees 13000ario
# ./realio-networkd tx gov vote 1 yes  --from validator2 --keyring-backend test --home ~/.realio-network/validator2 --chain-id realionetwork_3301-1 -y --fees 913000ario
# ./realio-networkd tx gov vote 1 yes  --from validator3 --keyring-backend test --home ~/.realio-network/validator3 --chain-id realionetwork_3301-1 -y --fees 73000ario
# ./realio-networkd tx gov vote 1 yes  --from validator4 --keyring-backend test --home ~/.realio-network/validator3 --chain-id realionetwork_3301-1 -y --fees 913000ario
# ./realio-networkd tx gov vote 1 yes  --from validator5 --keyring-backend test --home ~/.realio-network/validator3 --chain-id realionetwork_3301-1 -y --fees 913000ario


# sleep 7

# sleep 7
# ./realio-networkd tx multistaking create-validator ./validator4.json --from validator4 --keyring-backend test --home ~/.realio-network/validator3 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000
# ./realio-networkd tx multistaking create-validator ./validator5.json --from validator5 --keyring-backend test --home ~/.realio-network/validator3 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000
# sleep 7
# ./realio-networkd tx multistaking delegate realiovaloper1j7qsamh9t7mynehxz2svfrpqglyeexty2wfh49 1000000000000000000000arst --from validator1 --keyring-backend test --home ~/.realio-network/validator1 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000
# ./realio-networkd tx multistaking delegate realiovaloper1j7qsamh9t7mynehxz2svfrpqglyeexty2wfh49 2000000000000000000000arst --from validator2 --keyring-backend test --home ~/.realio-network/validator2 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000
# ./realio-networkd tx multistaking delegate realiovaloper1j7qsamh9t7mynehxz2svfrpqglyeexty2wfh49 3000000000000000000000arst --from validator3 --keyring-backend test --home ~/.realio-network/validator3 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000
# sleep 7
# ./realio-networkd tx multistaking unbond realiovaloper1j7qsamh9t7mynehxz2svfrpqglyeexty2wfh49 100000000000000000000arst --from validator1 --keyring-backend test --home ~/.realio-network/validator1 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000
# ./realio-networkd tx multistaking unbond realiovaloper1j7qsamh9t7mynehxz2svfrpqglyeexty2wfh49 200000000000000000000arst --from validator2 --keyring-backend test --home ~/.realio-network/validator2 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000
# ./realio-networkd tx multistaking unbond realiovaloper1j7qsamh9t7mynehxz2svfrpqglyeexty2wfh49 300000000000000000000arst --from validator3 --keyring-backend test --home ~/.realio-network/validator3 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000

# ./realio-networkd tx multistaking create-validator ./validator4.json --from validator4 --keyring-backend test --home ~/.realio-network/validator4 --chain-id realionetwork_3301-1 -y --fees 100ario --gas 4000000

# sleep 7
# ./realio-networkd q distribution rewards-by-validator realio1j7qsamh9t7mynehxz2svfrpqglyeexty762dyr realiovaloper1j7qsamh9t7mynehxz2svfrpqglyeexty2wfh49

# sleep 7
# ./realio-networkd q multistaking multistaking-locks 