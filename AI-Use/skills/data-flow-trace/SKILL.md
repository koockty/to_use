---
name: data-flow-trace
description: Use when the user asks to 梳理/讲解/搞清楚 a feature's data or state flow — how multiple scripts, services, functions, or tables collaborate, or why each field/table write happens. Produces a concrete minimal example with simulated row values that stay traceable across the whole chain, a phase-by-phase write table (table | field | value | why), and a summary table of why each table/component exists. Trigger words: 梳理, 数据流转, 怎么协同, 字段为什么写, 表为什么需要, trace data flow, 多脚本协同, 状态流转.
---

# 数据流转梳理 (data-flow-trace)

When the user wants to understand **how several scripts/services/functions/tables work together** for a feature, and **why each write happens**, produce the analysis below. Do not implement anything — this is a read-only explanation skill.

## Input contract

- The user provides: feature name, scope (optional), and any entry-point hints they already know (may be empty).
- Everything else you discover yourself from the code and schema: entry points, call chain, tables, fields, status values. Never ask the user for facts you can verify by reading code.

## Output structure (follow this order)

### 1. Construct a minimal example
- Pick the smallest concrete scenario that still exercises the interesting branch — usually **2 instances** are enough to show one-to-many / many-to-one or a status fork.
- Give every object a fixed id and field value, and keep them **identical across the whole chain** so a single value can be traced from start to finish.
- Use domain constraints the user gave, or infer them from the code logic if none were given.

### 2. Explain the flow phase by phase, in real execution order
Order by how it actually runs, **not** by file/directory layout.

For each phase, give a table with fixed 4 columns:

| 操作的表 | 字段 | 写入了什么值（用示例里的真实值）| 为什么写 |

Under each table, add one sentence stating the **phase boundary / transaction scope**: which writes are atomic together, and why they must be bound.

### 3. Proactively identify and explain these mechanisms (only if present)
- **State machine** — status values, who triggers transitions, whether reversible.
- **Placeholder-then-backfill** — an FK/id is written as a default (0/null/empty) before the target entity exists, then backfilled later.
- **Write-then-activate / soft-delete / delayed activation** — hidden via flag or timestamp, not physically deleted, then released all at once.
- **Concurrency & idempotency** — CAS / claim / unique constraint; how duplicate or concurrent execution is prevented.
- **Parent-child linkage** — direct FK vs. intermediate mapping table, and why that choice.
- **Transaction boundary** — which writes share one transaction; how failure rolls back.
- **Async & compensation / eventual consistency** — which data is written synchronously vs. compensated asynchronously, and the ordering.
- **Resumability** — breakpoint resume, idempotency markers, recovery from a half-done state.

### 4. Summarize and close
- One table: **each table / component → what it stores → why it needs to exist.**
- One sentence capturing the essence of the whole chain (e.g. "X is the work order, Y is the plan, Z is what actually mutates the data").

## Hard constraints

- Every table name, field name, and status value must come from the code or schema. Never fabricate.
- Every action must answer "why", not just describe "what happened".
- Write in Chinese, structured, table-first.
- If the user scoped the question (e.g. "only the split part"), stay inside that scope and say so.
