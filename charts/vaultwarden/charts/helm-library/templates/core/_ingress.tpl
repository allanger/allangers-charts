{{- define "lib.core.ingress" }}
---
# ---------------------------------------------------------------------
# -- This resource is managed by the allanger's helm library
# ---------------------------------------------------------------------
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  {{- .metadata | nindent 2 }}
spec:
  ingressClassName: {{ .spec.class }}
  {{- with .spec.rules }}
  rules:
    {{- tpl ( . | toYaml | nindent 4 | toString) $.ctx }}
  {{- end }}
  {{- with .spec.tls }}
  tls:
    {{- tpl ( . | toYaml | nindent 4 | toString) $.ctx }}
  {{- end }}
{{- end }}
