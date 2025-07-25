-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil zktest

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
DEFAULT_ZKSYNC_LOCAL_KEY := 0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install cyfrin/foundry-devops@0.2.2 && forge install foundry-rs/forge-std@v1.8.2 && forge install openzeppelin/openzeppelin-contracts@v5.0.2

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

zktest :; foundryup-zksync && forge test --zksync && foundryup

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --password-file .password --broadcast
LOCAL_ARGS := --rpc-url http://localhost:8545 --account defaultKey
SEPOLIA_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --account sepoliaKey --verify $(ETHERSCAN_API_KEY) -vvvv
ZKSYNC_ARGS := --rpc-url $(ZKSYNC_RPC_URL) --account zkSyncSepoliaKey


CONTRACT ?= Basic
deploy:
	forge script script/Deploy$(CONTRACT).s.sol:Deploy$(CONTRACT) $(NETWORK_ARGS) $(LOCAL_ARGS)
deploy-sepolia:; forge script script/Deploy$(CONTRACT).s.sol:Deploy$(CONTRACT) $(NETWORK_ARGS) $(SEPOLIA_ARGS)
deploy-zksync:; forge create src/OurToken.sol:OurToken $(ZKSYNC_ARGS) --legacy --zksync
	
mint:; forge script script/Interactions.s.sol:Mint$(CONTRACT) $(NETWORK_ARGS) $(LOCAL_ARGS)
mint-sepolia:; forge script script/Interactions.s.sol:Mint$(CONTRACT) $(NETWORK_ARGS) $(SEPOLIA_ARGS)

TOKEN_ID ?= 0
flipMoodNft:; TOKEN_ID=$(TOKEN_ID) forge script script/Interactions.s.sol:FlipMoodNft $(NETWORK_ARGS) $(LOCAL_ARGS)
flipMoodNft-sepolia:; TOKEN_ID=$(TOKEN_ID) forge script script/Interactions.s.sol:FlipMoodNft $(NETWORK_ARGS) $(SEPOLIA_ARGS)

AMOUNT ?= '3 ether'
callTransferFunctionDirectly:; TRANSFER_AMOUNT=$(AMOUNT) forge script script/Interactions.s.sol:CallTransferFunctionWithSelector $(NETWORK_ARGS) $(LOCAL_ARGS)
callTransferFunctionDirectly-sepolia:; TRANSFER_AMOUNT=$(AMOUNT) forge script script/Interactions.s.sol:CallTransferFunctionWithSelector $(NETWORK_ARGS) $(SEPOLIA_ARGS)
