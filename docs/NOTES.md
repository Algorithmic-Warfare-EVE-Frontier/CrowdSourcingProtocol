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


[2024-06-20]

# Integrating `EveWalletProvider` with `MudDevTools`

The mud dev tools setup happen before we get to login with the EVE wallet.

If we can find a way to load the account address into the the mud dev tools after we log in that is ideal.

The plan is as follows,

- Check if the `walletClient` interface matches from both sides.
  - In the case of the eve wallet, it is created using `createWalletClient` from `viem`.
  - Same in the case of the burner wallet in the `setupNetwork`.
  - They have compatible interfaces.
- Now, we need to find a way to switch the burner wallet for the eve or metamask wallet.
  - We need to have a hook that allows to change the wallet after the devtools are loaded to the interface.
  - The important part of about the wallet is that it is used to access the world contract, so we need to update that as well.
  - Since `WalletProvider` is top most, we just need to access the context it provides, see if `walletClient` is defined and loades it to the mud context.
    - That has been done
  - It seems that the eve wallet doesn't trully support metamask if you read the code it just shows the button to connect.
  - The idea is to only load the devtools when we login with the eve wallet using metamask.
    - However the chain data are wrong since it is doesnt support localhost so I only use the walletClient I get from the logic and the network data I reuse the default ones to get the right chain, rpc etc.