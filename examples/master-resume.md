# Alex Doe — Master Resume

> **This is a fictional example.** Alex Doe does not exist. Contoso, Fabrikam,
> Adventure Works, and Northwind Traders are standard placeholder company names.
> It is committed to this repo to show what a finished master resume looks like,
> and to give `scripts/txt_to_pdf.js` something to render as a smoke test.
>
> Your own `master-resume.md` lives at the repo root and is gitignored.

**Source of truth for every tailored resume and cover letter.** Tailored
documents SELECT from this file and reorder. They never invent, and they are
never the source for the next document.

---

## Contact

```
Alex Doe
Portland, OR | (555) 010-0123 | alex.doe@example.com | linkedin.com/in/alexdoe | alexdoe.example.com
```

## Education

```
Bachelor of Science, Computer Science | State University, Portland, OR    2016
```

---

## Roles I'm targeting

Senior individual-contributor backend or platform roles, ideally at companies
where infrastructure is treated as a product rather than a cost center. Remote,
or hybrid within Portland. Most interested in data pipelines, developer tooling,
and the reliability side of systems work. Open to a tech lead title but not
looking to move into people management in the next couple of years.

---

## Summary framings

**Backend / distributed systems:** Backend engineer with 8 years building and
operating high-throughput services in Go and Python. Owned an order pipeline
processing 4 million events a day through two major re-architectures, and cut its
p99 latency by two thirds without adding hardware. Comfortable being the person
who gets paged and the person who writes the postmortem.

**Platform / developer experience:** Backend engineer with 8 years of production
experience and a consistent pull toward the tooling other engineers depend on.
Built the internal deployment CLI now used by every team at Fabrikam, cutting
median time-to-first-deploy for new hires from three days to under an hour.
Equally happy in Go, Python, and Terraform.

**Data engineering:** Backend engineer with 8 years of experience, the last four
focused on data movement at scale. Designed and operated the Kafka-based event
backbone behind Fabrikam's analytics stack, and led the migration off a nightly
batch process that had been the source of most downstream data quality issues.

---

## Core skills and achievements

- **Distributed systems in production:** Owned Fabrikam's order-processing
  pipeline through two re-architectures while it grew from 400k to 4MM events a
  day, reducing p99 latency from 1.8s to 600ms on the same instance count.
- **Incident response and reliability:** Primary on-call for a tier-1 service for
  three years. Wrote the runbook and the postmortem template that the platform
  org adopted org-wide after a 90-minute outage in 2023.
- **Developer tooling:** Built and maintained `fab`, an internal deployment CLI
  in Go, adopted by all nine engineering teams. Cut median time from clone to
  first deploy for new engineers from three days to 40 minutes.
- **Data pipelines:** Designed the Kafka event backbone replacing a nightly batch
  job, moving analytics data freshness from 18 hours to under 5 minutes and
  eliminating the reconciliation class of bugs that caused it.
- **Mentorship:** Onboarded six engineers, two of them career changers. Ran a
  recurring code review clinic that ran for 14 months.
- **Cost work:** Cut Contoso's AWS spend 34% over two quarters by rightsizing
  instances and moving cold object storage to lifecycle policies, without a
  measurable change in service latency.

---

## Work experience — full bullet bank

### Senior Software Engineer | Fabrikam, Portland, OR (Remote) — 03/2021 – Present

- Owned the order-processing pipeline through two re-architectures as volume grew
  from 400k to 4MM events per day, reducing p99 latency from 1.8s to 600ms
  without increasing instance count
- Designed and shipped a Kafka-based event backbone to replace a nightly batch
  job, improving analytics data freshness from 18 hours to under 5 minutes
- Eliminated an entire class of reconciliation bugs by making the event stream
  the system of record instead of a downstream copy
- Built `fab`, an internal deployment CLI in Go, adopted by all nine engineering
  teams; reduced median time from repo clone to first successful deploy for new
  hires from three days to 40 minutes
- Served as primary on-call for a tier-1 service for three years, carrying the
  pager in a six-week rotation
- Led the incident review for a 90-minute checkout outage in 2023; the runbook
  and postmortem template written afterward were adopted across the platform org
- Migrated 40+ services from hand-maintained CloudFormation to Terraform modules,
  reducing environment drift between staging and production
- Introduced contract testing between the order service and its four downstream
  consumers, catching breaking schema changes in CI rather than in production
- Reduced CI pipeline runtime from 22 minutes to 7 by parallelizing the test
  suite and caching dependency layers
- Mentored six engineers through onboarding, including two career changers from
  non-CS backgrounds
- Ran a recurring code review clinic for 14 months, open to any engineer, focused
  on making review feedback specific and actionable
- Wrote the RFC process the backend org uses for cross-team design decisions
- Instrumented the order pipeline with OpenTelemetry tracing, making the
  previously invisible handoff between three services debuggable

### Software Engineer | Contoso Logistics, Portland, OR — 06/2018 – 03/2021

- Built and maintained the carrier integration service in Python, connecting to
  11 third-party shipping APIs with differing rate limits and failure modes
- Introduced a circuit breaker and retry-with-jitter layer that cut carrier-caused
  order failures by roughly 70%
- Reduced AWS spend by 34% over two quarters through instance rightsizing and
  S3 lifecycle policies, with no measurable latency regression
- Replaced a hand-rolled job scheduler with Celery, removing a recurring class of
  duplicate-execution bugs
- Added structured logging and correlation IDs across the service boundary,
  cutting mean time to diagnose a failed shipment from hours to minutes
- Wrote the team's first integration test suite against recorded carrier
  responses, making a previously untestable service safe to change
- Participated in interviewing and hiring for four backend roles

### Junior Software Engineer | Adventure Works, Eugene, OR — 07/2016 – 06/2018

- Built internal CRUD tools in Django for the operations team, replacing a
  spreadsheet-based workflow used by 30 people
- Maintained a legacy PHP storefront during a two-year migration to a Django
  backend, keeping it running while the replacement was built
- Automated a weekly manual reporting process that had taken an analyst most of a
  day, down to a scheduled job
- Fixed the top 20 recurring errors in the exception tracker over one quarter,
  reducing total error volume by about half

---

## Tech and tools inventory

- **Languages:** Go, Python, SQL, TypeScript, Bash, PHP (legacy maintenance only)
- **Frameworks:** Django, FastAPI, Celery, gRPC, Cobra (Go CLI)
- **Data:** PostgreSQL, Kafka, Redis, Snowflake, dbt
- **Infrastructure:** AWS (EC2, S3, RDS, Lambda, SQS), Terraform, Docker,
  Kubernetes, GitHub Actions
- **Observability:** OpenTelemetry, Datadog, Grafana, Prometheus, Sentry
- **Practices:** on-call rotation, incident review, RFC process, contract testing

---

## Canonical facts

- **Fabrikam title:** hired as "Software Engineer II", promoted to "Senior
  Software Engineer" in 09/2022. Use "Senior Software Engineer" with the full
  03/2021 start date; do not split it into two entries.
- **The 4MM events/day figure** is peak daily volume as of 2025, not an average.
  If a posting invites scrutiny of scale numbers, say "up to 4 million".
- **`fab` CLI adoption:** Alex built and maintained it, and it is used by all
  nine teams. Alex did not have formal authority over those teams. Do not write
  "drove company-wide adoption"; write "built" and let the usage speak.
- **Kubernetes:** deployed to and debugged in it, never administered a cluster.
  Frame as working knowledge, not expertise.
- **PHP:** maintenance of an existing storefront only, 2016-2018. Do not list it
  as a current skill unless a posting specifically asks.
