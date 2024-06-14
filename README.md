# PA - Crowd Sourcing Protocol
## Codename: CSP Net.

*This is still work in-progress.*

# Repo Building

1. This repo was created using the, `pnpm create mud@latest .` command and selected the `react` template.
2. I reverted to the playtest version using, `pnpm mud set-version --tag next-17-awakening && pnpm install`.
4. I also keep a clone of `world-chain-contracts` at the same level as this repo.
3. The development was mostly done locally in the case of `contracts`, both deployed to a new world via `pnpm run deploy:local` and to a world with `world-chain-contracts` on using, `pnpm run deploy:localworld`.
4. I added `viaIR=true` to the `foundry.toml` file to avoid `Stack too deep` errors.
5. In the case of the frontend, I cleared the `client` folder and populated it using, `npx @eveworld/create-eve-dapp --type scaffold .`

# General Directions 

In the meantime, you can check,
- `ROADMAP.md`, contains the execution steps and phases of this project.
- `REFLECTIONS.md`, sporadic logs that could serve at some point.
- `/docs`, to know about my ideation process in general.
  - `./docs/paper.pdf`, to see the origin of the idea and its conceptual backing.
  - `./docs/NOTES.md`, to view my study of the framework provided by CCP.
- Any known issue on this project is in the, `issues` section of this repo.

# Auhor's Note

Please keep in mind that this is a solo work, which I am attempting to undertake methodically and minimise cutting corners so that if there is someone jumping on this with me, they would be subject to the least amount of entropy possible.

They would still need to adjust to terminology and my own mess, I promise you, it all makes sense eventually.

My approach heavily relies on metaphoric thinking (see `Further Notes` below before reading the code, IMPORTANT!) where I try to smuggle contructs from physics and mathematics to the realm of social phenomoena, there are good reason for that, so you are expected to be flexible in how you view things and mostly question all of it.

I try to put a justification on every "awkward" choice I make. No pressure, take this as an exploration we aren't trying to solve the dynamics, a kinematic knowledge is enough for a start.

The code is commented and I always attempt a basic test coverage. I will work on it as we go.

Have fun!

# Further Notes

The `Crowd Sourcing Protocol` is based on the kickstarter idea but applied to clone-life. The point is to use this platform as a way to search for the best ideas on how to exploit space by leveraging ever-evolving collective processes and avoid being locked in one paradigm of play. 

The way I go about this is by applying my vision and the terminology that comes with it even at the level of code. This could be confusing but I try to lay down the mapping as simply as I can.

I think this a crucial point where one of the many interesting effects of language manifests. By just talking about something via metaphoric mapping we might figure out that our problem has a simpler description in the target domain and we just import solutions from one domain to another.

## Projects as Vectors

This came to be from an article I read few years ago (found as a reference in the `docs/paper.pdf`). 

The core of the idea is that by just existing somewhere as metabolism there is that imperative of survival. If left alone any metabolic entity will just whither and decay. If it is linked in any way to a psyche, the process is generally painful. 

By aversion, the entity will tend to fight these decaying forces and will seek nutrition to fuel its regerative processes and other processes that helps it get even more nutrition.

When we look at this metabolism from an information perspective, the entity needs to maintain its informational coherence, yet its activity or environment induces too much dissipation and information loss, so essentially it is fighting entropy.

And all of what I said, can be valid at a physical or sociatal level.

We represent this phenomenon, as a shrinking circle around the entity. As this circle gets smaller and smaller, it will eventually choke it to dead. 

The only way out is to escape out of the circle and position yourself somewhere, (1) either your circle is too big, you have too much resources or (2), the shrinking is slower, so you are not bleeding as fast.

To do this, you need a vector in that abstract space of resources and choking-entities. And the vector essentially translates in engaging in an activity or a project.
 
*At a deeper level, a vector also represents an insight driven from your initial position and the situation you were in. The vector injects information into a chaotic situation to induce order which can be either stable over a long period or generative of higher-order resources.*

*Note: keep in mind that the concept of entropic chock applies at any level, from individual to big groups. I like to think that the game in order to be engaging should have a game level entropic circle*

## Contributors as Potentials, Requests as Motions and Votes as Forces

When a "vector" project is proposed, players may help gathering the necessary resources based on their alignement with the vector's insight. In such case, the players become contributors.

If we look deeper at the situation each player has a subjectively unique view of the game and that dictates how they approach it and helps shape who they are in the game.

When two players interact on an idea (information field), despite the fact that their internal makeup and background is fundamentally different, they represent charges in that field. 

These charges will exchange energy (in our case, a player contributes to the project of another player) and that suggests a view of "players as potential sources".

When the target resources are reached. The vector handler will start issuing requests to use what was gathered and execute the idea in question.

The reason why I call requests motions, is because (1) they represent actual movement toward achieving the goal, (2) the vector is considered tangent to the motion as it describes its general direction.

When a motion is issued the potentials (now, contributing players), will vote on whether or not the motion should proceed or be halted. The outcome of the vote is viewed as the aggregate of all the potential-derived forces applied on the motion.

*All of this allows me to comment cool stuff like, "Make sure the potential strength doesn't overload the vector", or name a function `computeTangent` because it finds `vectorId` based on a `motionId` !!*

---
Abderraouf "k-symplex" Belalia <<abderraoufbelalia@symplectic.link>>