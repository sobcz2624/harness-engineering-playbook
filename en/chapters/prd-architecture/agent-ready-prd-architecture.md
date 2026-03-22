Chapter X | Agent-Ready PRD Architecture: From "Human-Readable PRD" to "Agent-Compilable PRD"


In traditional software engineering, we are used to the saying: code is primarily written for humans to read, and machines just happen to execute it. The core question was "how to make code elegant for humans."

But in the age of Agents, this saying needs to be rewritten.

For large-model Agents like Claude Code and Codex, code and documentation are fundamentally the same thing.
For humans, code is the implementation.
For Agents, code and documentation are two forms of the same thing:
documentation is the high-level specification, and code is the executable result after compiling that specification.
What truly determines delivery quality is no longer just code style, but whether the PRD can be reliably decomposed, understood, executed, and verified by the Agent.
The core question becomes "how to make specifications elegant for Agents."

This marks a critical shift:
we no longer pursue elegance and maintainability only from a human perspective, but must establish elegance and maintainability from the Agent's perspective.
Therefore, PRDs need architecture.
Without PRD architecture, Agents can only make large-span guesses each time;
with PRD architecture, Agents can produce stable output within the red-green-refactor loop.

---

Code engineering already has mature methods: event-driven architecture, MVC, singleton, factory patterns.
These methods all solve the same problem: clear boundaries, single responsibility, low coupling, high cohesion.

But the PRD domain has long been missing one thing: PRD architecture.
In the past, PRDs primarily served "humans reading and writing"; now they must serve "humans setting direction, Agents executing implementation."

Therefore, an Agent-oriented PRD should not be a monolithic specification document, but a recursively decomposable structured system:
starting from business intent, converging level by level to atomic tasks; each task is self-contained, boundary-clear, scope-controlled, and can directly enter the Agentic Loop (red-green-refactor).

This methodology can be summarized in one sentence:

PRD = a domain tree. The domain tree handles "from general to specific": decomposing business goals into complete and orthogonal subdomains, then grounding them into executable tasks.
Note: the concepts in this article can be directly applied using the skill prd-domain-tree-prover. Skill URL:
https://github.com/stock-programmer/xuwu-skills/tree/main/prd-domain-tree-prover

---

## 1. PRD Architecture Goals in the Agent Era

A qualified Agent-Ready PRD no longer just pursues "reads smoothly," but must satisfy four engineering goals:

1. Clear boundaries: each subdomain is responsible for only one category of core business logic.
2. Low coupling: cross-domain communication uses only contracts (API/Event), with no shared writable internal models.
3. Verifiable: completeness and orthogonality can be proven, not just "looks about right."
4. Compilable: ultimately grounded into atomic, self-contained task units with appropriate granularity.

---

## 2. Decomposition Process: Treating the PRD as "Compilable Input"

Use a "Domain Tree" to structure the PRD, from general to specific, from planning to execution.

First determine what capabilities the current node "must have" and "must not have," and find evidence for each capability. If evidence is insufficient, do not continue decomposing.

Decomposition must satisfy three constraint validations:

- C1 Completeness: every fact is covered and covered by exactly one domain.
- C2 Orthogonality: single-writer for state, single-producer for events, no shared write models.
- C3 Minimality: removing any domain loses capability; merging any two domains violates hard constraints (invariants, lifecycle, audit, isolation, permission boundaries).

Leaf domain grounding:

Only nodes that satisfy "independently implementable, independently permissioned, contracts complete, further decomposition would break consistency" qualify as leaf domains.
Leaf domains directly generate implementation specifications: entities, state machines, commands, events, APIs, storage, tests.


## 4. MES Example: Four Complete and Orthogonal Subdomains

Requirements:

> Build me an MES information system for factory production, specifically for tracking work orders, materials, and process workflows. During work order production, I need to bind materials. Materials have corresponding BOMs and BOM versions. The BOM stores all raw materials needed for producing the current material. Work orders can be bound to corresponding process routes and operation information. A process route corresponds to multiple operation steps, and each step needs its own handling method, which can be bound to personnel or equipment codes. Work order production must strictly follow the process steps for execution. Sequential or parallel execution of process steps needs to be considered. Work orders must have production batch quantity tracking for corresponding materials. At each process step, there must be batch quantity, good product and defective product quantity tracking. Each work order's process step must record station-passing information for production data traceability.

Your MES requirements can be stably decomposed into four first-level subdomains:

1. Work Order Lifecycle and BOM/Process Binding Snapshot
   Responsible for work order state progression, binding relationships, binding timestamps, and responsible person snapshots.
2. Material Master Data, BOM, and BOM Version Publishing
   Responsible for "what material to produce, what materials to use, what version it is" - master data and version governance.
3. Process Route, Operation Steps, and Step Handling Strategies
   Responsible for "how to do it," including sequential/parallel relationships, step strategies, personnel/equipment constraints.
4. Production Process Material Binding, Operation Execution, and Traceability
   Responsible for "what happened on the shop floor," including station-passing, batches, good/defective quantities, and execution traces.


These four subdomains are valid not because there happen to be four, but because they satisfy two engineering conditions:

1. Completeness: every key capability in the original requirements has a clear owner, with no capability gaps.
2. Orthogonality: core state is not redundantly written by multiple subdomains, avoiding responsibility overlap and state contention.

Furthermore, these four subdomains each answer different questions:
the work order domain answers "what state is the current document in, what snapshots are bound";
the material/BOM domain answers "what is the production object and material structure";
the process domain answers "how should it be done, in what sequence or parallel rules";
the execution traceability domain answers "what actually happened on the shop floor."

When these four types of questions are separated, the system gains the properties Agents need most:
clear inputs, unique responsibility, localized modifications, short verification paths.
These four domains are complete because they fully cover the closed loop from "define -> bind -> execute -> trace."
These four domains are orthogonal because each core writable state has a unique responsible party - no write contention, no redundant writes.


---

Subdomain Decomposition Mapped to Original Requirements

## Section 1: Restating the Original Requirements as Four Business Questions

1. Work orders must be controllable throughout their entire lifecycle from creation to completion, and must remember which BOM version and which process route they are bound to.
2. BOMs themselves must support maintenance and versioning; published versions must be traceable and reusable.
3. Process routes must be definable down to the operation level; each operation must have its own handling strategy and be able to constrain who or which equipment performs it.
4. The production floor must faithfully record every step of the execution process, including material batch binding, station-passing, good product and defective product quantities, and work order traceability.

## Section 2: What Each Subdomain Is Responsible For

### Subdomain 1: Work Order Lifecycle and BOM/Process Binding Snapshot

This subdomain is responsible only for the work order itself.
It answers: what stage is the work order in, which BOM version is bound, which process route is bound, when was the binding confirmed, and by whom.
It is not responsible for maintaining BOM content, nor for recording shop floor station-passing data.

Corresponding original requirements:
Work order production requires binding information.
Work orders can be bound to process routes and operation information.
Work order production must be constrained by the process.

### Subdomain 2: Material Master Data, BOM, and Version Publishing

This subdomain is responsible only for "what material to produce, what materials to use, what version it is."
It maintains material master data, BOM structure, and version publishing and effectivity relationships.
It is not responsible for work order state progression, nor for shop floor execution records.

Corresponding original requirements:
Materials have corresponding BOMs and BOM versions.
The BOM defines all raw materials needed for producing the current material.

### Subdomain 3: Process Route, Operation Steps, and Step Handling Strategies

This subdomain is responsible only for "how to do it."
It maintains process routes, operation steps, step sequencing or parallelism relationships, and handling strategies for each step.
Personnel or equipment codes, as part of execution constraints, are also defined here.
It is not responsible for work order progression, nor for shop floor quantity reporting.

Corresponding original requirements:
A process route corresponds to multiple operation steps.
Each step has its own handling method.
Steps can be bound to personnel or equipment codes.
Sequential or parallel execution needs to be considered.

### Subdomain 4: Production Process Material Binding, Operation Execution, and Traceability

This subdomain is responsible only for "what happened on the shop floor."
It records station-passing at each operation for the work order, material batch binding, input/output quantities, and good/defective product quantities.
It is responsible for consolidating execution facts into traceable records.
It does not define BOM structure, nor does it define process version content.

Corresponding original requirements:
Material binding must occur during work order production.
Each process step must have batch quantity, good product and defective product tracking.
Each work order's process step must record station-passing information for traceability.

## Section 3: Why These Four Subdomains Are Complete

Complete means: every key capability in your original requirements has an owner, with no gaps.

1. Track work orders: the first subdomain handles state and binding snapshots; the fourth subdomain supplements with shop floor execution traces.
2. Track materials: the second subdomain defines material usage rules; the fourth subdomain records actual batch consumption.
3. Track processes: the third subdomain defines routes and steps; the fourth subdomain records execution results for each step.
4. Mid-process binding in work orders: the first subdomain manages binding relationships; the fourth subdomain records runtime binding facts.
5. Sequential and parallel execution: the third subdomain defines the relationships; the fourth subdomain executes accordingly and leaves an audit trail.
6. Batches and good/defective quantities: the fourth subdomain uniformly records and provides traceability queries.

Therefore, your requirements' main workflow from "definition" to "binding" to "execution" to "traceability" forms a complete closed loop with no omissions.

## Section 4: Why These Four Subdomains Are Orthogonal

Orthogonal means: responsibilities are clear, with no overlapping writes to the same category of core data.

1. The first subdomain writes only work orders and binding snapshots.
2. The second subdomain writes only materials and BOM versions.
3. The third subdomain writes only process routes and step strategies.
4. The fourth subdomain writes only shop floor execution and traceability facts.

With this separation, each category of core state has exactly one responsible party, eliminating write contention between subdomains.
Subdomains collaborate through agreed-upon messages or interfaces, rather than sharing a single internally mutable dataset.

## Section 5: Are Four Subdomains Hardcoded?

No, they are not hardcoded.
These four subdomains are the result of systematically consolidating capability points from the original requirements.
If you add new capabilities such as "shift scheduling," "equipment maintenance," or "quality release approval," the number and boundaries of subdomains will change accordingly. The number will not be permanently fixed at four.


---

## 5. From Domain Tree to Executable Leaf Tasks

First write the PRD as a provable domain tree, then compile the domain tree into executable leaf tasks.
The Agent is not "reading documentation" - it is "compiling architecture";
without PRD architecture, there is no stable software generation capability.

Treating documentation as microservices: from a master document to execution documents.
Articulate goals, capability closures, domain trees, cross-domain contracts, and acceptance criteria. This determines "what to do, who is responsible." This is "documentation as microservice composition": the backbone is the domain tree.

This is also the core value of Harness Engineering in Agent-driven development:
not treating the Agent as "a faster programmer," but restructuring the delivery process as "an orchestrable cognitive pipeline."

From a master document to microservice-style documents, this can be structured into four layers:

1. Master PRD: defines business goals, scope, constraints, and success criteria.
2. Subdomain specifications: defines each domain's responsibility boundaries, master data, events, and interfaces.
3. Atomic task cards: each card does one thing, with verifiable completion conditions.
4. Execution evidence stream: test results, change records, and regression conclusions form a trust closed loop.

When documentation reaches this level, Agent generation behavior no longer depends on "guessing context," but advances steadily along structured boundaries.
What you get then is not just "code that runs," but "a system that can be sustainably iterated."

---

In closing:

The number of subdomains is never hardcoded.
It is the natural result of "consolidating, deduplicating, and assigning responsibility" across business capability points.
When scheduling, equipment maintenance, or quality release approval are added, the domain tree expands;
when capabilities disappear or merge, the domain tree contracts.

Therefore, PRD architecture is not a document formatting standard, but a software engineering methodology designed for Agents.
It enables "ideas" to be provably transformed into "tasks," and "tasks" to be verifiably transformed into "systems."
