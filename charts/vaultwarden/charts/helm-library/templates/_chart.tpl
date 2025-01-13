{{/*
	* Expand the name of the chart.
*/}}
{{- define "lib.chart.name" -}} {{- /* define[0] */}}
{{- include "lib.error.noCtx" . -}}
{{- default .ctx.Chart.Name .ctx.Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }} {{- /*/define[0] */}}

{{/*
	* Create chart name and version as used by the chart label.
*/}}
{{- define "lib.chart.chart" -}} {{- /* define[0] */}}
{{- include "lib.error.noCtx" . -}}
{{- printf "%s-%s" .ctx.Chart.Name .ctx.Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }} {{- /*/define[0] */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "lib.chart.fullname" -}}
{{- include "lib.error.noCtx" . -}}
{{- if .ctx.Values.fullnameOverride }}
{{- .ctx.Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .ctx.Chart.Name .ctx.Values.nameOverride }}
{{- if contains $name .ctx.Release.Name }}
{{- .ctx.Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .ctx.Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
	* Common labels
*/}}
{{- define "lib.chart.labels" -}} {{- /* define[0] */}}
{{- include "lib.error.noCtx" . -}}
helm.sh/chart: {{ include "lib.chart.chart" (dict "ctx" .ctx) }}
{{ include "lib.chart.selectorLabels" (dict "ctx" .ctx) }}
{{- if .ctx.Chart.AppVersion }} {{- /* if[1] */}}
app.kubernetes.io/version: {{ .ctx.Chart.AppVersion | quote }}
{{- end }} {{- /* /if[1] */}}
app.kubernetes.io/managed-by: {{ .ctx.Release.Service }}
{{- end }} {{- /*/define[0] */}}

{{/*
	* Selector labels
*/}}
{{- define "lib.chart.selectorLabels" -}} {{- /* define[0] */}}
{{- include "lib.error.noCtx" . -}}
app.kubernetes.io/name: {{ include "lib.chart.name" (dict "ctx" .ctx) }}
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
{{- end }} {{- /*/define[0] */}}

