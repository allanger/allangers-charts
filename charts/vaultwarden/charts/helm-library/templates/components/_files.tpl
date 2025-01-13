{{/*
	* This component should make it easier to create sets
	* of environment variables via configmaps and secrets
*/}}
{{- define "lib.component.files" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- range $k, $v := .ctx.Values.config.files }} {{- /* range[0] */}}
{{- $customName := include "lib.component.file.name" (dict "ctx" $.ctx "name" $k) }}
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
		"annotations" $v.annotations
		"labels" $labels
	) 
}}
{{- $entries := dict -}}
{{- range $key, $value := $v.entries }} {{- /* range[1] */}}
{{- if not (has $key ($v.remove)) }} {{- /* if[1] */}}
{{- $data := $value.data }}
{{- if and (kindIs "string" $data) ($value.convertTo) }} {{- /* if[2] */}}
{{- fail "convering is only possible for plain yaml, strings are not supported" -}}
{{- end }} {{- /* /if[2] */}}
{{- if $value.convertTo -}} {{- /* if[2] */ -}}
{{- if eq $value.convertTo "json" }} {{- /* if[3] */}}
{{- $data = include "lib.helpers.convertToJson" $data -}}
{{- else if eq $value.convertTo "toml" -}}
{{- $data = include "lib.helpers.convertToToml" $data -}}
{{- else if eq $value.convertTo "yaml" -}}
{{- $data = include "lib.helpers.convertToYaml" $data -}}
{{- else -}}
{{- fail (printf "converion to %s is not supported yet" $value.convertTo) -}}
{{- end -}} {{- /* /if[3] */ -}}
{{- end -}} {{- /* /if[2] */ -}}
{{- if not (kindIs "string" $data) -}}
{{- fail (printf "it must be a string, but it's a %s: %v" (kindOf $data) $data) -}}
{{- end -}}
{{- $_ := set $entries $key (tpl $data $.ctx) }}
{{- end }} {{- /* /if[1] */}}
{{- end }} {{- /* /range[1] */}}
{{- if $v.sensitive }} {{- /* if[1] */}}
{{ include "lib.core.secret" (dict "ctx" $ "metadata" $metadata "data" $entries) }}
{{- else }}
{{ include "lib.core.configmap" (dict "ctx" $ "metadata" $metadata "data" $entries) }}
{{- end -}} {{- /* /if[1] */}}
{{- end }} {{- /* /if[0] */}}
{{- end }} {{- /* /range[0] */}}
{{- end -}} {{- /* /define[0] */ -}}

{{- define "lib.component.file.name" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- include "lib.error.noKey" (dict "ctx" . "key" "name") -}}
{{ printf "%s-%s-file" .ctx.Release.Name .name }}
{{- end -}} {{- /* /define[0] */ -}}
