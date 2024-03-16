## chain-abstraction

### Prerequisites

Required packages:
- [Foundry Forge](https://book.getfoundry.sh/forge/)
- [Bun](https://bun.sh/)

### Getting Started

To run a local SUAVE node, run the following: 
1. `curl -L https://suaveup.flashbots.net | bash` to download the node
2. `suave-geth --suave.dev` to start the node

Next, deploy contracts to the local node:
- `forge script script/Setup.s.sol:SetupScript --rpc-url http://localhost:8545 --broadcast`

Run the script to send confidential request to the contract:
- `bun run index.ts`