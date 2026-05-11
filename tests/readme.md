# Functional / Integration Tests

Build checks alone are not enough to verify that an OS image actually works at runtime.

For example:
- Steam could crash on launch after an upstream regression
- a dependency update could break desktop startup
- Flatpak integration could silently stop working

Traditional build validation mainly confirms that:
- the image builds successfully
- dependencies resolve correctly
- packages install without conflicts

Fedora already provides strong guarantees in those areas. However, those checks do not validate the final integrated system behavior.

These tests add runtime validation for the produced image itself, helping catch regressions that only appear after boot.

Current coverage includes:
1. System successfully boots and reaches graphical session

2. Basic CLI operations execute successfully
   - create, move, and delete files/directories

3. Expected image components are present
   - CachyOS kernel
   - Plasma session

4. Flatpak functionality works correctly
   - add/remove remotes
   - install applications
   - launch installed applications

The long-term goal is to expand coverage for critical user workflows and common failure scenarios.