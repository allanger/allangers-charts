{{- define "lib.helpers.lookup.env" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- include "lib.error.noKey" (dict "ctx" . "key" "key") -}}
{{- $data := (index .ctx.Values.config.env .key) -}}
{{- if not $data }} {{- /* if[1] */}}
{{- fail (printf "entry %s is not found in env" .key) }}
{{- else -}} {{- /* .if[1] */ -}}
{{ toYaml $data }}
{{- end -}} {{- /* /if[1] */ -}}
{{- end -}} {{- /* /define[0] */ -}}

{{- define "lib.helpers.lookup.storage" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- include "lib.error.noKey" (dict "ctx" . "key" "key") -}}
{{- $data := (index .ctx.Values.storage .key) -}}
{{- if not $data }} {{- /* if[1] */}}
{{- fail (printf "entry %s is not found in storage" .key) }}
{{- else -}} {{- /* .if[1] */ -}}
{{ toYaml $data }}
{{- end -}} {{- /* /if[1] */ -}}
{{- end -}} {{- /* /define[0] */ -}}

{{- define "lib.helpers.lookup.service" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- include "lib.error.noKey" (dict "ctx" . "key" "key") -}}
{{- $data := (index .ctx.Values.services .key) -}}
{{- if not $data }} {{- /* if[1] */}}
{{- fail (printf "entry %s is not found in services" .key) }}
{{- else -}} {{- /* .if[1] */ -}}
{{ toYaml $data }}
{{- end -}} {{- /* /if[1] */ -}}
{{- end -}} {{- /* /define[0] */ -}}
