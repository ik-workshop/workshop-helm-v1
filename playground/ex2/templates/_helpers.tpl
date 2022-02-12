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

{{- define "ex.apm.afinityifelseinline" -}}

{{- if and .Values.affinity (eq .Values.apm "enabled") }}
{{- if not (hasKey .Values.affinity "nodeAffinity") -}}
{{/* lets support case when nodeAffinity is not defined */}}
{{- range $key, $value := $.Values.affinity }}
  {{ $key }}:
    {{- toYaml $value | nindent 6 }}
{{- end }}
  nodeAffinity:
    {{- include "ex.apm.afinity" . | nindent 4 }}
{{- else if and (hasKey .Values.affinity "nodeAffinity") (not (hasKey .Values.affinity.nodeAffinity "requiredDuringSchedulingIgnoredDuringExecution")) -}}
{{/* nodeAffinity present and not present requiredDuringSchedulingIgnoredDuringExecution  */}}
{{- range $key, $value := $.Values.affinity }}
  {{ $key }}:
    {{- toYaml $value | nindent 6 }}
    {{- if (eq $key "nodeAffinity") }}
  {{- include "ex.apm.afinity" . | nindent 4 }}
    {{- end }}
{{- end }}
{{- else if and (hasKey .Values.affinity "nodeAffinity") (hasKey .Values.affinity.nodeAffinity "requiredDuringSchedulingIgnoredDuringExecution") -}}
{{/* nodeAffinity and requiredDuringSchedulingIgnoredDuringExecution both present. Apm not enabled. Should Warn!!  */}}
{{- .Values.affinity | toYaml | nindent 2 }}
{{ end }}
{{- else if and .Values.affinity }}
{{- .Values.affinity | toYaml | nindent 2 }}
{{- else if (eq .Values.apm "enabled") }}
nodeAffinity:
  {{- include "ex.apm.afinity" . | nindent 4 }}
{{ end }}
{{- end }}
