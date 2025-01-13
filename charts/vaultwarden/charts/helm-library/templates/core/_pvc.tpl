{{- define "lib.core.pvc" -}}
---
# ---------------------------------------------------------------------
# -- This resource is managed by the allanger's helm library
# ---------------------------------------------------------------------
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  {{- .metadata | nindent 2 }}
spec:
{{- with .spec.accessModes }}
  accessModes:
{{ toYaml . | indent 4}}
{{- end }}
  resources:
    requests:
      storage: {{ .spec.size }}
{{- if ne .spec.storageClassName "default" }}
  storageClassName: {{ .spec.storageClassName }}
{{- end }}
{{- end -}}
