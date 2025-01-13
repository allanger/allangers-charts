{{- define "lib.component.ingress" }}
{{- range $k, $v := .ctx.Values.ingress }}
{{- $customName := include "lib.component.ingress.name" (dict "ctx" $.ctx "name" $k) }}
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
{{- $spec := $v -}}
{{- $_ := unset $spec "enabled" -}}
{{ include "lib.core.ingress" (dict "ctx" $.ctx "metadata" $metadata "spec" $spec ) }}
{{- end }}
{{- end }}
{{- end }}

{{- define "lib.component.ingress.name" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- include "lib.error.noKey" (dict "ctx" . "key" "name") -}}
{{ printf "%s-%s" .ctx.Release.Name .name }}
{{- end -}} {{- /* /define[0] */ -}}
