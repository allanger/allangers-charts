{{/*
	* This component should make it easier to create pvc
*/}}
{{- define "lib.component.storage" -}}
{{- include "lib.error.noCtx" . -}}
{{- range $k, $v := .ctx.Values.storage }}
{{- $customName := include "lib.component.storage.name" (dict "ctx" $.ctx "name" $k) }}
{{- if $v.enabled }} {{- /* if[0] */}}
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
		"annotations" ($v.metadata).annotations
		"labels" $labels
		"name" $customName
	) 
}}
{{ include "lib.core.pvc" (dict "metadata" $metadata "spec" $v) }}
{{- end }} {{- /* /if[0] */}}
{{- end }}
{{- end -}}

{{- define "lib.component.storage.name" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- include "lib.error.noKey" (dict "ctx" . "key" "name") -}}
{{ printf "%s-%s-storage" .ctx.Release.Name .name }}
{{- end -}} {{- /* /define[0] */ -}}
