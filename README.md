## 2024 Paradigm Fellowship application - Technical Problems

### Environment

To run the code in this repository, you need to have the following installed on your machine:
- Node.js(We recommend using [nvm](https://github.com/nvm-sh/nvm) and installing Node.js version 20)
- [Foundry](https://github.com/foundry-rs/foundry/releases)

Before running the code, you need to install the dependencies by running the following command:
```shell
git submodule update --init --recursive
npm install
```

### Problem 1

#### Content

Demonstrate an EVM simulation including tracing against a forked Ethereum mainnet or other chain in a programming language of your choice.

#### Answer

First, we run the following command to start a forked Ethereum mainnet using the Anvil tool:
```shell
anvil --fork-url $MAINNET_RPC_URL --port 8545
```

Then, we interact with the forked mainnet using the following code:
```shell
npx hardhat run script/Deploy.s.js --network fork
```

In `script/Deploy.s.js`, we deploy a contract(actually the gaussian for problem 2) to the forked mainnet and test the precision of the calculation.

### Problem 2

#### Content

Implement a maximally optimized gaussian CDF on the EVM for arbitrary 18 decimal fixed point parameters x, μ, σ. Assume -1e20 ≤ μ ≤ 1e20 and 0 < σ ≤ 1e19. Should have an error less than 1e-8 vs errcw/gaussian for all x on the interval [-1e23, 1e23].

#### Answer

We implement the gaussian CDF in the `src/Gaussian.sol` file. The function `cdf` calculates the Gaussian cumulative distribution function for 18 decimal fixed-point parameters $x, \mu, \sigma$. For example, if we pass parameters $x=1e18, \mu=5e17, \sigma=5e17$ for `cdf`, the function will calculate the Gaussian cumulative distribution function at $x=1$ with mean $\mu=0.5$ and standard deviation $\sigma=0.5$. The function returns the result as a fixed-point number with 18 decimal places, which is $0.84134e18$.

The function `cdf` is tested in the `test/Gaussian.t.sol` file. Run
```shell
forge test
```
to see the result.


### Problem 3

#### Content

An Ethereum contract is funded with 1,000 ETH. It costs 1 ETH to call, which is added to the balance. If the contract isn't called for 10 blocks, the last caller gets the entire ETH balance. How might this game unfold and end? Describe your thinking.

#### Answer

In developing the following solution, certain assumptions were made to facilitate the process. However, it is important to note that these assumptions are based on limited knowledge and may not fully capture the complexities of the problem domain.

At the very beginning, we give the following assumptions:

- The amount of ETH caused by sending a transaction is negligible compared with what we are working on during our discussion.
- The total supply of ETH is approximately uniformly distributed among all identities. (Otherwise, proof of stake would be meaningless.)

We give a simple argument to show that the game is almost a lottery. Let's consider three users $A$, $B$ and $C$, each having 1ETH. Suppose someone calls the contract first, without loss of generality, let's say $A$. Now $B$ and $C$ will make their decisions(call or not call) exactly at the 10th block after $A$'s call, otherwise the other one will definitely win the game. If both $B$ and $C$ call the contract, they will have the same chance to win the game. If only one of them calls the contract, the other guy will win the game. If neither of them calls the contract, $A$ will win. The Nash equilibrium of $B$ and $C$ will be calling the contract, and they'll win with eqaul probability. However, in practice, there are many uncertainties, such as network latency, or gas fee, or even collusion with miner(the winning of game will produce huge profit), which make "making a decision at exactly the 10th block" impossible, and $A$ also has a fair probability to win if $B$ and $C$ don't have their calls included in time. We are not giving a detailed analysis of these uncertainties, but we believe that it's fair to say that the game is almost a lottery, given the assumption that the total supply of ETH is approximately uniformly distributed among all identities.

We have seen how people play a lottery game in real blockchain world: mining pools appeared in Bitcoin mining, so that a stable income can be obtained from mining even if the miner's hash power is low. We believe that "pool contract" will appear in this game, and rational players will join the pool to get a fair share of the final award. The pool contract will be a smart contract where players can deposit their ETH, and those who have deposited their stake can make decisions on whether to call the contract or not(work much like a DAO, and we assume that a decision can be made in a decentralized way in a short time). The pool contract will have a mechanism to distribute the final award to the players who have deposited their stake. There might be many different designs of pool contracts. When one design outperforms others significantly, the decision makers of those pools will switch to a better one, and finally a pool contract with the most(in stake) supporters will be the winner.


### Problem 4

#### Content

What change would you make to Uniswap v2 if you wanted to prevent or mitigate "sandwich attacks"?

#### Answer

Not answered.

### Problem 5

#### Content

Imagine you are both an NFT exchange seeking to enforce NFT royalties, and an NFT trader seeking to evade NFT royalties. What is the most effective technical solution to enforce royalties and to evade them? We encourage you to play out the arms race.

#### Answer

Not answered.

### Problem 6

#### Content

If you were planning to do an airdrop and wanted to only reward legitimate users, what sort of on-chain and/or off-chain data would you collect and how would you use it to identify sybil clusters?

#### Answer

Not answered.
