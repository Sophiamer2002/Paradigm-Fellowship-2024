const gaussian = require('gaussian');
const hre = require('hardhat');
const ethers = hre.ethers;

async function main() {
    const g = await ethers.getContractFactory('Gaussian');
    const Gaussian = await g.deploy();

    // Gaussian CDF implemented in Solidity
    const myGaussianCDF = async function(x, mean, variance) {
        // turn x, mean, variance into fixed point numbers
        x = ethers.parseUnits(String(x), 18);
        mean = ethers.parseUnits(String(mean), 18);
        variance = ethers.parseUnits(String(variance), 18);

        res = await Gaussian.cdf(x, mean, variance);
        return Number(ethers.formatUnits(res, 18));
    }

    const errcwGaussianCDF = function(x, mean, variance) {
        let d = gaussian(mean, variance * variance);
        return d.cdf(x);
    }

    const test = async function(x, mean, variance) {
        let res1 = await myGaussianCDF(x, mean, variance);
        let res2 = errcwGaussianCDF(x, mean, variance);
        console.log(`x: ${x}, mean: ${mean}, variance: ${variance}`);
        console.log(`myGaussianCDF: ${res1}`);
        console.log(`errcwGaussianCDF: ${res2}`);
        console.log(`diff: ${Math.abs(res1 - res2)}`);
        console.log();
    }

    await test(0, 0, 1);
    await test(1, 0, 1);
    await test(2, 0, 1);
    await test(4, 0, 1);
    await test(1e16, 3e16, 4e16);
    await test(1e20, 3e16, 4e16);
    await test(1e13, 3e16, 4e16);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
