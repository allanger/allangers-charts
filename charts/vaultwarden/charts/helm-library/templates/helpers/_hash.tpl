{{/*
	* Populate hashes from configmaps and secret to
	* trigger pod restart after config was changed
	* TODO: Remove the extra empty line after annotations
*/}}
{{- define "lib.helpers.hashes" -}} {{- /* define[0] */ -}}
# ---------------------------------------------------------------------
# -- A note from the library:
# -- Pod annotations currently only support hashes of mounted 
# -- config files and env variables and annotations inherited from 
# -- the deployment
# ---------------------------------------------------------------------
{{ range $k, $v := .env -}} {{/* range[1] */ -}}
{{- if $v.enabled -}} {{- /* if[2] */ -}}
{{
	include "lib.helpers.hash"
	(dict "kind" "env" "name" $k "data" $v.data)
}}
{{ end -}} {{/* /if[2] */ -}}
{{- end -}} {{- /* /range[1] */ -}}
{{ range $k, $v := .files -}} {{/* range[1] */ -}}
{{
	include "lib.helpers.hash"
	(dict "kind" "file" "name" $k "data" ($v).entries)
}}
{{- end -}} {{- /* /range[1] */ -}}
{{- end -}} {{- /* /define[0] */ -}}

{{- define "lib.helpers.hash" -}} {{- /* define[0] */ -}}
{{ printf "helm.badhouseplants.net/%s-%s" .kind .name }}: {{ .data | toString | sha256sum }}
{{- end -}} {{- /* /end[0] */ -}}
