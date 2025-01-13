{{/*
	* This component should make it easier to create pvc
*/}}
{{- define "lib.component.service" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- range $k, $v := .ctx.Values.services }} {{- /* range[1] */}}
{{- $customName := include "lib.component.service.name" (dict "ctx" $.ctx "name" $k) }}
{{- if $v.enabled }} {{- /* if[2] */}}
{{-
	$labels := include "lib.metadata.mergeLabels"
	(dict
		"ctx" $.ctx
		"global" ($.ctx.Values.metadata).labels
		"local" ($v.metadata).labels
	)
}}
{{- 
	$metadata := include "lib.metadata" 
	(dict 
		"ctx" $.ctx 
		"name" $customName 
		"annotations" ($v.metadata).annotations
		"labels" $labels
	) 
}}
{{ $spec := $v }}
{{- if not $spec.type -}}
{{- set $spec "type" "ClusterIP" -}}
{{- end }}
{{ 
  include "lib.core.service"
  (dict "ctx" $.ctx "metadata" $metadata "spec" $spec)
}}
{{- end }}
{{- end }}
{{- end -}} {{- /* /define[0] */ -}}

{{- define "lib.component.service.name" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- include "lib.error.noKey" (dict "ctx" . "key" "name") -}}
{{ printf "%s-%s" .ctx.Release.Name .name }}
{{- end -}} {{- /* /define[0] */ -}}
