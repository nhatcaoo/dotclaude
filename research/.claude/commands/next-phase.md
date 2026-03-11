Advance to the next RIPER phase.

1. Detect current phase from the latest file in the project folder
2. Confirm human approved current phase output
3. Invoke the appropriate agent for the next phase:
   R → I: invoke architect (create options.md)
   I → P: wait for human to choose option, then invoke tech-advisor + estimator
   P → E: invoke spec-writer (create 05-spec.md)
   E → R: do review pass, list any gaps vs 01-requirements.md
4. State the new phase clearly: [PHASE: X — Description]
