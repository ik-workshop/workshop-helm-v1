# Exercise 2. Merge Object and feature Flag

This example showcase the following problem:

- There is a flag `apm (enabled|disabled)`
- When pod `affinity` is set as well as `apm=enabled` it should be enriched with extra `required` node affinity

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Contents

- [Commands](#commands)
- [Otputs](#otputs)
  - [Case 0](#case-0)
  - [Case 1](#case-1)
  - [Case 3](#case-3)
  - [Case 4](#case-4)
  - [Case 5](#case-5)
- [Resources](#resources)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Commands

```sh
mk template name=ex2
```

## Otputs

### Case 0

_Input_

```yaml
affinity: {}
apm: disabled
```

_Output_

```yaml
# Source: exercise/templates/test.yaml
affinity:
```

### Case 1

_Input_

```yml
affinity: {}
apm: enabled
```

_Output_

```yml
# Source: exercise/templates/test.yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: apm
          operator: In
          values:
          - enabled
```

### Case 3

_Input_

```yml
affinity:
  podAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: service
            operator: In
            values: [“S1”]
        topologyKey: failure-domain.beta.kubernetes.io/zone
  nodeAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        preference:
          matchExpressions:
          - key: another-node-label-key
            operator: In
            values:
            - another-node-label-value
apm: disabled
```

_Output_

```yml
affinity:
    nodeAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
      - preference:
          matchExpressions:
          - key: another-node-label-key
            operator: In
            values:
            - another-node-label-value
        weight: 1
    podAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: service
            operator: In
            values:
            - “S1”
        topologyKey: failure-domain.beta.kubernetes.io/zone
```

### Case 4

_Input_

```yaml
affinity:
  podAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: service
            operator: In
            values: [“S1”]
        topologyKey: failure-domain.beta.kubernetes.io/zone
  nodeAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        preference:
          matchExpressions:
          - key: another-node-label-key
            operator: In
            values:
            - another-node-label-value
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
          - key: kubernetes.io/e2e-az-name
            operator: In
            values:
            - e2e-az1
            - e2e-az2
apm: enabled
```

_Output_

```sh
Error: execution error at (exercise/templates/test.yaml:2:4): This version of the chart does not support `apm=enabled` and .affinity.requiredDuringSchedulingIgnoredDuringExecution at the same time
```

### Case 5

_Input_

```yaml
affinity:
  podAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: service
            operator: In
            values: [“S1”]
        topologyKey: failure-domain.beta.kubernetes.io/zone
  nodeAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        preference:
          matchExpressions:
          - key: another-node-label-key
            operator: In
            values:
            - another-node-label-value
apm: enabled
```

_Output_

```yml
affinity:
  nodeAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - preference:
        matchExpressions:
        - key: another-node-label-key
          operator: In
          values:
          - another-node-label-value
      weight: 1
  requiredDuringSchedulingIgnoredDuringExecution:
    nodeSelectorTerms:
    - matchExpressions:
      - key: apm
        operator: In
        values:
        - enabled
  podAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchExpressions:
        - key: service
          operator: In
          values:
          - “S1”
      topologyKey: failure-domain.beta.kubernetes.io/zone
```

## Resources

- [K8s: Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)
- [Helm: named teampltes](https://helm.sh/docs/chart_template_guide/named_templates/)
- [Helm: advanced Techniques](https://blog.flant.com/advanced-helm-templating/)
- [Helm: chart tips and tricks](https://helm.sh/docs/howto/charts_tips_and_tricks/)
