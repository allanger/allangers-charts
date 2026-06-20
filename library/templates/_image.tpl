{{- define "image.bootstrap" -}}
{{- include "lib.error.noCtx" . -}}
{{- $image := "" }}
{{- if .image.registry }}
{{- $image = printf "%s/" .image.registry }}
{{- end }}
{{- $tag := .ctx.Chart.AppVersion }}
{{- if .image.tag }}
{{- $tag = .image.tag }}
{{- end }}
{{- printf "%s%s:%s" $image .image.repository $tag }}
{{- end }}
