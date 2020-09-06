/* 코드 7-4 */

// ①
const { accounts, contract, web3 } = require('@openzeppelin/test-environment')

// ②
const {
  BN,
  constants,
  expectEvent,
  expectRevert,
} = require('@openzeppelin/test-helpers')

// ③
const { expect } = require('chai').use(require('chai-as-promised')).should();

// ④
const RoomFactory = contract.fromArtifact('RoomFactory')

// ⑤
describe('RoomFactory', function () {
    const [factoryOwner, roomOwner1] = accounts

    // ⑥
    beforeEach(async function () {
        this.roomFactory = await RoomFactory.new({ from: factoryOwner })
    })

    // ⑦
    it('should exist', function () {
        this.roomFactory.should.exist
    })

    describe('createRoom', function () {
        const amount = web3.utils.toWei('1', 'ether')

        // ⑧
        it('should create a room', async function () {
            const { logs } = await this.roomFactory.createRoom({ from: roomOwner1, value: amount })
            const event = await expectEvent.inLogs(logs, 'RoomCreated')

            const factoryBalance = await web3.eth.getBalance(this.roomFactory.address)
            const roomBalance = await web3.eth.getBalance(event.args._room)
                
            factoryBalance.should.be.bignumber.equal('0')
            // factoryBalance.should.be.bignumber.equal(amount)

            roomBalance.should.be.bignumber.equal(amount)
        })

        // ⑨
        it('only the factory owner can pause createRoom', async function () {
            await this.roomFactory.paused({ from: roomOwner1 }).should.be.rejectedWith
            await this.roomFactory.paused({ from: factoryOwner }).should.be.fulfilled
        })
    })
})

/* 코드 7-5
const { accounts, contract, web3 } = require('@openzeppelin/test-environment')

const {
  BN,
  constants,
  expectEvent,
  expectRevert,
} = require('@openzeppelin/test-helpers')

const { expect } = require('chai').use(require('chai-as-promised')).should();

const RoomFactory = contract.fromArtifact('RoomFactory')

describe('RoomFactory', function () {
    const [factoryOwner, roomOwner1, roomOwner2, roomOwner3] = accounts

    beforeEach(async function () {
        this.roomFactory = await RoomFactory.new({ from: factoryOwner })
    })

    it('should exist', function () {
        this.roomFactory.should.exist
    })

    describe('createRoom', function () {
        const amount = web3.utils.toWei('1', 'ether')
        it('should create a room', async function () {
            const { logs } = await this.roomFactory.createRoom({ from: roomOwner1, value: amount })
            const event = await expectEvent.inLogs(logs, 'RoomCreated')

            const factoryBalance = await web3.eth.getBalance(this.roomFactory.address)
            const roomBalance = await web3.eth.getBalance(event.args._room)

            factoryBalance.should.be.bignumber.equal('0')
            roomBalance.should.be.bignumber.equal(amount)
        })

        it('should emit a RoomCreated event', async function () {
            const { logs } = await this.roomFactory.createRoom({ from: roomOwner1, value: amount })
            const event = await expectEvent.inLogs(logs, 'RoomCreated')

            event.args._creator.should.equal(roomOwner1)
            event.args._room.should.equal(event.args._room)
            event.args._depositedValue.should.be.bignumber.equal(amount)
        })

        it('can create multiple rooms', async function () {
            const { logs: logs1 } = await this.roomFactory.createRoom({ from: roomOwner1, value: amount })
            const { logs: logs2 } = await this.roomFactory.createRoom({ from: roomOwner2, value: amount })
            const { logs: logs3 } = await this.roomFactory.createRoom({ from: roomOwner3, value: 0 })

            const event1 = await expectEvent.inLogs(logs1, 'RoomCreated')
            const event2 = await expectEvent.inLogs(logs2, 'RoomCreated')
            const event3 = await expectEvent.inLogs(logs3, 'RoomCreated')

            const factoryBalance = await web3.eth.getBalance(this.roomFactory.address)
            const roomBalance1 = await web3.eth.getBalance(event1.args._room)
            const roomBalance2 = await web3.eth.getBalance(event2.args._room)
            const roomBalance3 = await web3.eth.getBalance(event3.args._room)

            factoryBalance.should.be.bignumber.equal('0')
            roomBalance1.should.be.bignumber.equal(amount)
            roomBalance2.should.be.bignumber.equal(amount)
            roomBalance3.should.be.bignumber.equal('0')
        })

        it('can accept an empty deposit', async function () {
            const { logs } = await this.roomFactory.createRoom({ from: roomOwner1, value: web3.utils.toWei('0', 'ether') })
            const event = await expectEvent.inLogs(logs, 'RoomCreated')

            const factoryBalance = await web3.eth.getBalance(this.roomFactory.address)
            const roomBalance = await web3.eth.getBalance(event.args._room)

            factoryBalance.should.be.bignumber.equal('0')
            roomBalance.should.be.bignumber.equal('0')
        })

        it('can pause createRoom', async function () {
            await this.roomFactory.paused({ from: factoryOwner })
            await this.roomFactory.createRoom({ from: roomOwner1, value: amount }).should.be.rejectedWith
        })

        it('only the factory owner can pause createRoom', async function () {
            await this.roomFactory.paused({ from: roomOwner1 }).should.be.rejectedWith
            await this.roomFactory.paused({ from: factoryOwner }).should.be.fulfilled
        })
    })
}) */