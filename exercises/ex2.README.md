# Exercise 2. Merge Object and feature Flag

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Contents

- [Commands](#commands)
- [Otputs](#otputs)
  - [Case 0](#case-0)
  - [Case 1](#case-1)
  - [Case 3](#case-3)
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

## Resources
