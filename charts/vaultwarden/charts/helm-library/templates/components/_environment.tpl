{{/*
	* This component should make it easier to create sets
	* of environment variables via configmaps and secrets
*/}}
{{- define "lib.component.environment" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- range $k, $v := .ctx.Values.config.env }} {{- /* range[0] */}}
{{- $customName := include "lib.component.env.name" (dict "ctx" $.ctx "name" $k) }}
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
		"name" $customName 
		"annotations" ($v.metadata).annotations
		"labels" $labels
	) 
}}
{{- $data := dict -}}
{{- range $key, $value := $v.data }} {{- /* range[1] */}}
{{- if not (has $key ($v.remove)) }} {{- /* if[1] */}}
{{- $_ := set $data $key (tpl (toString $value) $.ctx) }}
{{- end }} {{- /* /if[1] */}}
{{- end }} {{- /* /range[1] */}}
{{- if $v.sensitive }} {{- /* if[1] */}}
{{ include "lib.core.secret" (dict "ctx" $ "metadata" $metadata "data" $data) }}
{{- else }}
{{ include "lib.core.configmap" (dict "ctx" $ "metadata" $metadata "data" $data) }}
{{- end -}} {{- /* /if[1] */}}
{{- end }} {{- /* /if[0] */}}
{{- end }} {{- /* /range[0] */}}
{{- end -}} {{- /* /define[0] */ -}}

{{- define "lib.component.env.name" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- include "lib.error.noKey" (dict "ctx" . "key" "name") -}}
{{ printf "%s-%s-env" .ctx.Release.Name .name }}
{{- end -}} {{- /* /define[0] */ -}}
