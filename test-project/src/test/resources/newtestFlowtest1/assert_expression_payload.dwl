%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo([
  "Melba",
  "Annie",
  "Jack",
  "Kate"
])