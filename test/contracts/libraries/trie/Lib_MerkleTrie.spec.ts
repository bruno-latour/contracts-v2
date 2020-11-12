import { expect } from '../../../setup'

/* External Imports */
import { ethers } from 'hardhat'
import { Contract } from 'ethers'

/* Internal Imports */
import { TrieTestGenerator } from '../../../helpers'

const NODE_COUNTS = [1, 2, 128]

describe('Lib_MerkleTrie', () => {
  let Lib_MerkleTrie: Contract
  before(async () => {
    Lib_MerkleTrie = await (
      await ethers.getContractFactory('TestLib_MerkleTrie')
    ).deploy()
  })

  describe('verifyInclusionProof', () => {
    for (const nodeCount of NODE_COUNTS) {
      describe(`inside a trie with ${nodeCount} nodes`, () => {
        let generator: TrieTestGenerator
        before(async () => {
          generator = await TrieTestGenerator.fromRandom({
            seed: `seed.incluson.${nodeCount}`,
            nodeCount,
            secure: false,
          })
        })

        for (
          let i = 0;
          i < nodeCount;
          i += nodeCount / (nodeCount > 8 ? 8 : 1)
        ) {
          it(`should correctly prove inclusion for node #${i}`, async () => {
            const test = await generator.makeInclusionProofTest(i)

            expect(
              await Lib_MerkleTrie.verifyInclusionProof(
                test.key,
                test.val,
                test.proof,
                test.root
              )
            ).to.equal(true)
          })
        }
      })
    }
  })

  describe('update', () => {
    for (const nodeCount of NODE_COUNTS) {
      describe(`inside a trie with ${nodeCount} nodes`, () => {
        let generator: TrieTestGenerator
        before(async () => {
          generator = await TrieTestGenerator.fromRandom({
            seed: `seed.update.${nodeCount}`,
            nodeCount,
            secure: false,
          })
        })

        for (
          let i = 0;
          i < nodeCount;
          i += nodeCount / (nodeCount > 8 ? 8 : 1)
        ) {
          it(`should correctly update node #${i}`, async () => {
            const test = await generator.makeNodeUpdateTest(
              i,
              '0x1234123412341234'
            )

            expect(
              await Lib_MerkleTrie.update(
                test.key,
                test.val,
                test.proof,
                test.root
              )
            ).to.equal(test.newRoot)
          })
        }
      })
    }
  })

  describe('get', () => {
    for (const nodeCount of NODE_COUNTS) {
      describe(`inside a trie with ${nodeCount} nodes`, () => {
        let generator: TrieTestGenerator
        before(async () => {
          generator = await TrieTestGenerator.fromRandom({
            seed: `seed.get.${nodeCount}`,
            nodeCount,
            secure: false,
          })
        })

        for (
          let i = 0;
          i < nodeCount;
          i += nodeCount / (nodeCount > 8 ? 8 : 1)
        ) {
          it(`should correctly get the value of node #${i}`, async () => {
            const test = await generator.makeInclusionProofTest(i)

            expect(
              await Lib_MerkleTrie.get(test.key, test.proof, test.root)
            ).to.deep.equal([true, test.val])
          })
        }
      })
    }
  })
})
