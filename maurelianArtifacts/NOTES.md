## Recommendations

- Consider fixing external/public modifiers
- Rename predeploys to indicate they are predeploys



## L2 -> L1 Miniaudit

### To Verify:

- [ ] There is no way for a contract on L1 or L2 to “trick” the messengers by sending a message which looks like it came from a different account.
- [ ] Messages cannot be manipulated or altered--if the message passers say a particular message was sent, then it was exactly that data which was passed to sendMessage.
- [ ] Messages can always be sent using these messengers, and if sent, will always be received if the user takes sufficient action.
- [ ] L2->L1 messages cannot be verified “early”, i.e. before the dispute period for the L2 transaction which sent the message has elapsed.




### Scope: 

Low level source code: `iOVM_L2ToL1MessagePasser`
- TODO: move that code into wherever it gets called from
ExecutionManager
