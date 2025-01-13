{{/*
   * This template should be able to create a valid container spec
*/}}
{{- define "lib.core.pod.container" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- include "lib.error.noKey" (dict "ctx" . "key" "data") -}}
{{- include "lib.error.noKey" (dict "ctx" . "key" "name") -}}
name: {{ .name }}
{{ include "lib.core.pod.container.securityContext" (dict "securityContext" .data.securityContext) }}
{{ include "lib.core.pod.container.command" (dict "command" .data.command) }}
{{ include "lib.core.pod.container.args" (dict "args" .data.command) }}
{{ include "lib.core.pod.container.livenessProbe" (dict "ctx" .ctx "probe" .data.livenessProbe) }}
{{ include "lib.core.pod.container.readinessProbe" (dict "ctx" .ctx "probe" .data.readinessProbe) }}
{{ include "lib.core.pod.container.startupProbe" (dict "ctx" .ctx "probe" .data.readinessProbe) }}
{{ include "lib.core.pod.container.image" (dict "ctx" .ctx "image" .data.image) }}
{{ include "lib.core.pod.container.envFrom" (dict "ctx" .ctx "envFrom" .data.envFrom) }}
{{ include "lib.core.pod.container.volumeMounts" (dict "ctx" .ctx "mounts" .data.volumeMounts) }}
{{ include "lib.core.pod.container.ports" (dict "ctx" .ctx "ports" .data.ports) }}
{{- /*
{{-
  include "lib.core.pod.container.ports" 
    (dict "Context" .Context "Container" .ContainerData) 
    | indent 2 
-}}
{{- 
  include "lib.core.pod.container.volumeMounts" 
    .ContainerData | indent 2 
-}}
*/}}
{{- end -}} {{- /* /define[0] */ -}}

{{- define "lib.core.pod.container.securityContext" }} {{- /* define[0] */ -}}
securityContext:
{{- if  not .securityContext }} {{- /* if[1] */}}
# ---------------------------------------------------------------------
# Using the default security context, if it doesn't work for you,
# please update `.Values.base.workload.containers[].securityContext`
# ---------------------------------------------------------------------
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - ALL
{{- else }}
{{- with .securityContext }} {{- /* with[2] */}}
{{ toYaml . | indent 2 }}
{{- end }} {{- /* /with[2] */}}
{{- end -}} {{- /* /if[1] */ -}}
{{- end -}} {{- /* /define[0] */ -}}

{{/* 
  * Command and Args are accepting a dict as an argument
	* dict should contain the following keys:
	* 	- ctx
	* 	- command/args (optional list) - When empty, entry is not added
*/}}
{{- define "lib.core.pod.container.command" -}} {{- /* define[0] */ -}}
{{- with .command -}} {{- /* with[1] */ -}}
command:
{{ . | toYaml | indent 2 }}
{{- end -}} {{- /* /with[1] */ -}}
{{- end -}} {{- /* /define[0] */ -}}

{{- define "lib.core.pod.container.args" -}} {{- /* define[0] */ -}}
{{- with .args -}} {{- /* with[1] */ -}}
args: 
{{ . | toYaml | indent 2 }}
{{- end -}} {{- /* /with[1] */ -}}
{{- end -}} {{- /* /define[0] */ -}}

{{/* 
  * Probes are accepting a dict as an argument
	* dict should contain the following keys:
	* 	- ctx
	* 	- probe (optional) - When empty, probe is not added
  *
  * Notes: Probes can be tempalted, because some kinds of probes
  * need to be aware of a port to be checking against. And to avoid
  * copypaste all the probes are tempalted
*/}}

{{- define "lib.core.pod.container.readinessProbe" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- include "lib.error.noKey" (dict "ctx" . "key" "probe") -}}
{{- if .probe }} {{- /* if[1] */}}
{{- $probe := tpl (toYaml .probe) .ctx -}}
readinessProbe:
{{ $probe | indent 2}}
{{- end }} {{- /* /if[1] */}}
{{- end -}} {{- /* /define[0] */ -}}

{{- define "lib.core.pod.container.livenessProbe" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- include "lib.error.noKey" (dict "ctx" . "key" "probe") -}}
{{- if .probe }} {{- /* if[1] */}}
{{- $probe := tpl (toYaml .probe) .ctx -}}
livenessProbe:
{{ $probe | indent 2}}
{{- end }} {{- /* /if[1] */}}
{{- end -}} {{- /* /define[0] */ -}}

{{- define "lib.core.pod.container.startupProbe" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- include "lib.error.noKey" (dict "ctx" . "key" "probe") -}}
{{- if .probe }} {{- /* if[1] */}}
{{- $probe := tpl (toYaml .probe) .ctx -}}
startupProbe:
{{ $probe | indent 2}}
{{- end }} {{- /* /if[1] */}}
{{- end -}} {{- /* /define[0] */ -}}

{{- define "lib.core.pod.container.image" -}} {{/* define[0] */}}
{{- include "lib.error.noCtx" . -}}
{{- include "lib.error.noKey" (dict "ctx" . "key" "image") -}}
image: {{ printf "%s/%s:%s" 
  .image.registry .image.repository 
  (include "lib.core.pod.container.image.tag"
  (dict "appVersion" .ctx.Chart.AppVersion "tag" .image.tag)) 
}}
imagePullPolicy: {{ .image.pullPolicy | default "Always" }}
{{- end -}} {{/* /define[0] */}}

{{/*
  * EnvFrom can either take values from predefined env values
  * or add a raw envFrom entries to the manifests
  * When using the predefined env, it's possible to remove entries
  * using the '.remove' entry from the env mountpoint
  * 
  * Should accept a dict with the followibg keys
  * ctx
  * envFrom
  * 
*/}}
{{- define "lib.core.pod.container.envFrom" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- include "lib.error.noKey" (dict "ctx" . "key" "envFrom") -}}
{{- /* If env should be set from a Configmap/Secret */ -}}
{{- if .envFrom -}} {{- /* if[1] */ -}}
envFrom:
{{- range $k, $v := .envFrom -}} {{- /* range[2] */ -}}
{{- if not (eq $k "raw") -}} {{- /* if[3] */ -}}
{{- $source := include "lib.helpers.lookup.env" (dict "ctx" $.ctx "key" $k) | fromYaml }}
{{- if $source.sensitive }}
  - secretRef:
{{- else }}
  - configMapRef:
{{- end }}
      name: {{ include "lib.component.env.name" (dict "ctx" $.ctx "name" $k) }}
{{- else -}}
  {{ $v | toYaml | nindent 2}}
{{- end }} {{- /* if[3] */}}
{{- end }} {{- /* /range[2] */}}

{{- end -}} {{- /* /if[1] */ -}}
{{- end -}} {{- /* /define[0] */ -}}

{{- define "lib.core.pod.container.volumeMounts" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- include "lib.error.noKey" (dict "ctx" . "key" "mounts") -}}
{{- if .mounts }} {{- /* if[1] */}}
volumeMounts:
{{- range $mountKind, $mountData := .mounts }} {{- /* range[1] */}}
{{- if eq $mountKind "storage" }} {{- /* if[2] */}}
{{- range $mountName, $mountEntry := $mountData }} {{- /* range[3] */}}
{{- $name := include "lib.component.storage.name" (dict "ctx" $.ctx "name" $mountName) }}
  - name: {{ $mountName }}-storage
    mountPath: {{ $mountEntry.path }} 
{{- end }} {{- /* /range[1] */}}
{{- end }} {{- /* /if[1] */}}
{{- if eq $mountKind "files" }} {{- /* if[1] */}}
{{- range $mountName, $mountEntry := $mountData }} {{- /* range[1] */}}
{{- $name := include "lib.component.file.name" (dict "ctx" $.ctx "name" $mountName) }}
  - name: {{ $name }}
    mountPath: {{ $mountEntry.path }} 
{{- if $mountEntry.subPath }} {{- /* if[2] */}}
    subPath: {{ $mountEntry.subPath }}
{{- end }} {{- /* /if[2] */}}
{{- end }} {{- /* /range[1] */}}
{{- end }} {{- /* /if[1] */}}
{{- if eq $mountKind "extraVolumes" }} {{- /* if[1] */}}
{{- range $mountName, $mountEntry := $mountData }} {{- /* range[1] */}}
  - name: {{ printf "%s-extra" $mountName }}
    mountPath: {{ $mountEntry.path }} 
{{- end }} {{- /* /range[1] */}}
{{- end }} {{- /* /if[1] */}}
{{- end }} {{- /* /range[0] */}}
{{- end }} {{- /* /if[0] */}}
{{- end -}} {{- /* /define[0] */ -}}

{{- define "lib.core.pod.container.ports" -}} {{- /* define[0] */ -}}
{{- include "lib.error.noCtx" . -}}
{{- include "lib.error.noKey" (dict "ctx" . "key" "ports") -}}
{{- if .ports }} {{- /* if[0] */}}
ports:
{{- range $k, $v := .ports }} {{- /* range[0] */}}
{{- if and (kindIs "string" $v) (eq $k "raw") }} {{- /* if[1] */}}
{{- fail "raw port should be an array of ports" -}}
{{- end -}}

{{- if ne $k "raw" }}
{{- $service := include "lib.helpers.lookup.service" (dict "ctx" $.ctx "key" $k) | fromYaml -}}
{{- $ports := index $service "ports" }}
{{- range $port := $v }}
{{- $protocol := index (index $ports $port) "protocol" }}
{{- $containerPort := index (index $ports $port) "targetPort" }}
  - containerPort: {{ $containerPort }}
    protocol: {{ $protocol }}
{{- end }}
{{- else }}
{{ $v | toYaml | indent 2 -}}
{{- end -}} {{- /* /if[1] */ -}}
{{- end -}} {{- /* /range[0] */ -}}
{{- end -}} {{- /* /if[1] */ -}}
{{- end -}} {{- /* /define[0] */ -}}

