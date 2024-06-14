# Backend Notes

*Need to bring my notes from obsidian to here.*

---
# Frontend Notes



# `WalletProvider`

## What does it provide?

1. `state`, the state of the wallet,
```tsx
// This is the schema of the state
const initialState = {
  connected: false,
  connectedChainId: 0,
  defaultNetwork: {
    networks: testnetChains,
    baseChain: testnetChains[0],
    worldAddress: "0x",
    erc2771ForwarderAddress: "0x",
  },
  smartCharacter: undefined,
  publicClient: null,
  walletClient: null,
  bundlerClient: null,
  isHeadless: false,
};

```
2. `protocol`, the way to access the `gatewayApiUrl`.
3. `gatewayApiUrl`, where to pull information on smart objects from.
4. `handleConnect`, `handleDisconnect`, handlers for wallet connection states.
5. `availableWallets`, a list of available wallets.

# `WorldProvider`

## What does it provide?

1. `world`, world contract interface.
2. `trustedForwarder`, forwarder contract interface.


# `SmartObjecProvider`

## What does it provide?
This makes four things available,
1. `smartCharacter`, information on the smart character pulled from the `WalletContext`.
2. `smartDeployable`, information on the accessed smart unit pulled from the game.
3. `loading`, status on the provider activity.
4. `isCurrentChain`, checks if the chain on which the deployable exists matches the one on which character exists. (Or so I think)

### Interesting Notes
The smart object ID is passed as an argument when it is accessed from outside, like through the wallet in your browser.

You can pass the SOID in the url while accessing the DApp using the param, `http://127.0.0.1:3000/?smartObjectId=111692850832374932496207213553394323705854985720762582578169171704618020548223`.

When you do this the provider will pull information about that specific object from the Testnet.

Maybe I can make it work localhost?

---
#### [SOLVED] Issue 1: Bad Display

Replace, `'./../shared/ui-components/*/*.{js,ts,jsx,tsx}',` with `"./node_modules/@eveworld/ui-components/*/*.{js,ts,jsx,tsx}",`, in the `tailwind.config.js`.

Explanation:

The default path doesn't reference the components provided by `@eveworld/ui-components` correctly.