{{/*
Admin creds for the recovery mode
*/}}
{{- define "stalwart.admin" -}}
{{ printf "%s:%s" .Values.config.recoveryAdmin.username .Values.config.recoveryAdmin.password | b64enc }}
{{- end }}
