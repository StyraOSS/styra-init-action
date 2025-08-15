package main

import rego.v1

self := "StyraOSS/styra-init-action"

init_job := id if {
	some id, job in input.jobs
	some step in job.steps
	[self, _] = split(step.uses, "@")
}

allowed_action_refs["actions/setup-node"] := {"39370e3970a6d050c480ffad4ff0ed4d3fdee5af"}

allowed_action_refs["actions/checkout"] := {"11bd71901bbe5b1630ceea73d27597364c9af683"}

deny contains "workflow does not use init action" if not init_job

deny contains msg if {
	some [name, ref] in actions
	not is_sha_hash(ref)
	lower(name) != "styraoss/styra-init-action" # the only exception, this action itself
	msg := sprintf("action %s uses tag %s, should be pinned to SHA hash", [name, ref])
}

deny contains msg if {
	some id, _ in input.jobs
	not init_job in graph.reachable(job_graph, {id})
	msg := sprintf("job %s does not (transitively) depend on init job (%s)", [id, init_job])
}

warn contains msg if {
	false # disabled
	some [name, ref] in actions
	not in_allowlist(name, ref)
	msg := sprintf("action %s@%s not in allow-list", [name, ref])
}

actions contains action if {
	some id, job in input.jobs
	some step in job.steps
	action := split(step.uses, "@")
}

# job_graph[x] := [a, b, c] for a job defined like
# x:
#   needs:
#     - a
#     - b
#     - c
job_graph[id] := needs(job) if some id, job in input.jobs

needs(job) := [job.needs] if not is_array(job.needs)
needs(job) := job.needs if is_array(job.needs)
needs(job) := [] if not job.needs

is_sha_hash(s) if regex.match(`^[a-f0-9]{40}$`, s)

in_allowlist(n, r) if r in allowed_action_refs[n]
