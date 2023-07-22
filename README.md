Demurrage Token
===

This is code from an old contract that my client let me keep. It is over 4 years old IIRC :)

Needs work to catch up with 2023!

To-Do
---
* Fix the 2 failing test which appear related to mining behaviours, probably not re-fetching the exact point release of Ganache.
* Solidity 0.4 -> 0.8 !
* Move to Forge
* Use invariant testing, which is really appropriate for this code!
* I think all the included 3rd party code is available as libraries now

Outstanding Design Issues
---
* How well do wallets cope with tokens disappearing without an event emitted? 🤔