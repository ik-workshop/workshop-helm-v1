{{/*
Expand the name of the chart.
*/}}
{{- define "ex.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "additionalNodeAffinity" }}
{{ with .affinity }}
	{{- toYaml (merge . (fromYaml (include "ex.apm.afinity" .))) }}
{{ end }}
{{- end }}

{{- define "returnJson" }}
  {{- $result := dict "requiredDuringSchedulingIgnoredDuringExecution" (dict "nestedKey1" "nestedVal1") }}
  {{- $result | toJson }}
{{- end }}

{{- define "returnYaml" }}
  {{- $result := dict "requiredDuringSchedulingIgnoredDuringExecution" (dict "nestedKey1" "nestedVal1") }}
  {{- $result | toYaml }}
{{- end }}

{{- define "ex.typeOf.affinity" }}
  {{- $.Values.affinity | typeOf }}
{{- end }}

{{/*
Renders a value that contains template.
Usage:
{{ include "ex.tplValue" (dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "ex.tplValue" -}}
    {{- if typeIs "string" .value }}
        <!-- do nothing for now -->
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

<!-- REQUIRED only this one -->
{{- define "ex.apm.afinity" -}}
requiredDuringSchedulingIgnoredDuringExecution:
  nodeSelectorTerms:
  - matchExpressions:
    - key: apm
      operator: In
      values:
      - enabled
{{- end }}
