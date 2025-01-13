{{- define "lib.error.noCtx" -}} {{- /* define[0] */ -}}
{{- if not .ctx -}}{{- fail "no context provided" -}}{{- end -}}
{{- if not (kindIs "map" .ctx) -}} {{- /* if[1] */ -}}
{{- fail "unexpected type of ctx" -}}
{{- end -}} {{- /* /if[1] */ -}}
{{- end -}} {{- /* /define[0] */ -}}

{{- define "lib.error.noKey" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- if not .key -}}{{ fail "error handler must receive a key to find" }}{{- end -}}
{{- if not (hasKey .ctx .key) -}} {{- /* if[1] */ -}}
{{- fail (printf "key %s must be not null" .key) -}}
{{- end -}} {{- /* /if[1] */ -}}
{{- end -}} {{- /* /define[0] */ -}}

