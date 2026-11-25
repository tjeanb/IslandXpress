# ADR-002: Architectural Decision

**Status:** Accepted

**Choice:** Amazon EKS for the development environment.

**Problem it solves:** Provides a managed Kubernetes environment for practicing cloud-native infrastructure and operations.

**Why this choice:** Develop practical AWS and Kubernetes engineering skills through hands-on deployment, automation, security, and troubleshooting.
**Alternative considered:** EC2 with Docker and ECS with Fargate.

**Why not here:**They could satisfy the application's hosting requirements, but would not provide the same Kubernetes-specific learning opportunities.

**Trade-off accepted:** Increased infrastructure complexity, provisioning time, and potentially higher costs.

**What would make me choose differently:** A real production deployment with a smaller operational team, tight budget, and no Kubernetes-specific requirements.