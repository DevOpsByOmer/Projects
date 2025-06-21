{{/* Define chart name and fullname */}}
{{- define "frontend.name" -}}
frontend
{{- end -}}

{{- define "frontend.fullname" -}}
{{ include "frontend.name" . }}-app
{{- end -}}
