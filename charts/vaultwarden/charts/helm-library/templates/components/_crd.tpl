{{/*
	* CRDs should always be managed as a separate chart
	* They must be written to the ./crd folder and then 
	* they will be read by the .Files helm feature
*/}}
{{- define "lib.component.crd" -}} {{- /* define[0] */ -}}
{{- 
	$metadata := include "lib.metadata" 
	(dict "ctx" $ "annotations" .Values.workload.annotations) 
}}
{{ $currentScope := .}}
{{ range $path, $_ :=  .Files.Glob  "**.yaml" }}
    {{- with $currentScope}}
        {{ .Files.Get $path }}
    {{- end }}
{{ end }}
{{- end -}} {{- /* define[0] */ -}}
