/* 코드 6-12

const RoomFactory = artifacts.require('../contracts/RoomFactory.sol')

module.exports = deployer => {
    deployer.deploy(RoomFactory)
} */

/* 코드 6-13 */
const RoomFactory = artifacts.require('../contracts/RoomFactory.sol')

module.exports = deployer => {
    deployer.deploy(RoomFactory).then(instance => {
        console.log('ABI:', JSON.stringify(instance.abi))
    })
}