{{- define "lib.helpers.convertToJson" -}}
{{ toString (toJson . ) }}
{{- end -}}

{{- define "lib.helpers.convertToToml" -}}
{{ toString (toToml .) }}
{{- end -}}

{{- define "lib.helpers.convertToYaml" -}}
{{ toString (toYaml .) }}
{{- end -}}
