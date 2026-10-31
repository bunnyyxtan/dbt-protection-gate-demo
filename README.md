# dbt Test Protection Regression Gate: demo project

A tiny dbt project on DuckDB used by the Kestra blueprint `dbt-test-protection-regression-gate`. Each commit is one
scenario: a change to the project's data tests that the gate should accept, block, or refuse to judge.

The project has two models (`orders`, `customers`) and six singular data tests under `tests/`:
`id_present`, `id_unique`, `amount_nonnegative`, `orders_not_empty`, `customer_exists`, `status_valid`.

## Scenarios

Use any two commits as `base_sha` and `candidate_sha` in the blueprint. The gate corrupts copies of the built
`orders` table with six required defects and compares what each revision's tests catch.

| Commit | Scenario | Change | Expected decision (base = baseline) |
|---|---|---|---|
| `a8aa5e45de2926a305e5d6b1f84b8d882d73ed87` | baseline | six data tests | (reference) |
| `c039a86a2ffef94c40bd3810312c14d13e583f61` | weakened | amount test relaxed to `amount < -1000` | BLOCK: LOST_PROTECTION |
| `9fa60f44b5854ff54ce185cbda325714a0732a88` | repaired | amount test restored | PASS |
| `86c22230196ba298a5dadf2c303e7db0a35a6138` | harmless | amount test renamed, equivalent predicate | PASS |
| `642e302ee47abb2bff6f54c7fbc2d21b576b13e6` | broken | amount test refs a missing model | INCONCLUSIVE |
| `84444892cc09d439084689f8719268ad56422ff7` | weakened_with_unrelated_failure | relaxed amount test plus an unrelated test the defect trips | BLOCK |
| `ac011a3a707b655bf1ebf8717385ca7c8ebc0661` | test_removed | amount test deleted | BLOCK |
| `978e4f9f934c32ff515e4b4dca0f8c0c6cc3bd3f` | runtime_error | amount test reads a missing column | INCONCLUSIVE |
| `0a2af3c4cbc65eeba5ed4848d37fc3f0dd777e70` | renamed_unlisted | amount test renamed to a name the catalog does not list | BLOCK |
| `f80e2f1b6f33e75b95779680bd093ba3280c56e4` | weakened_three | amount, emptiness and customer tests relaxed | BLOCK |
| `38860aa180defbde0b9af88cba873092857c1395` | model_change | model SQL changed | UNSUPPORTED |

With `weakened` as base and `repaired` as candidate the decision is PASS (the candidate gains protection).

## Run it yourself without Kestra

```bash
git checkout a8aa5e45de2926a305e5d6b1f84b8d882d73ed87
pip install "dbt-core==1.11.7" "dbt-duckdb==1.10.1"
cat > profiles.yml <<'EOF'
shop:
  target: dev
  outputs:
    dev: {type: duckdb, path: shop.duckdb, schema: main, threads: 1}
EOF
dbt run --profiles-dir . && dbt test --profiles-dir .
```

This repository only holds the demo project. The gate itself, its catalog of defects and its evidence reports live
in the Kestra blueprint.
