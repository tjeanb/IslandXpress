# ADR-001: Ephemeral AWS Development Environment

**Status:** Accepted

**Choice:** Ephemeral AWS development environment.

**Problem it solves:** Avoids paying for idle infrastructure while studying over multiple days.

**Why this choice:** This project is a portfolio engineering environment, not a live business serving customers.

**Alternative considered:** Permanently running AWS infrastructure.

**Why not here:** Continuous availability isn't necessary for development and would increase costs.

**Trade-off accepted:** Provisioning time, environment resets and extra cleanup work.

**What would make me choose differently:** Real customers, continuous demonstrations, or a requirement to test sustained availability.