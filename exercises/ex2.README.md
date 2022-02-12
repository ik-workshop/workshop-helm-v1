# Exercise 2. Merge Object and feature Flag

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Contents

- [Commands](#commands)
- [Otputs](#otputs)
  - [Case 0](#case-0)
  - [Case 1](#case-1)
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

## Resources
