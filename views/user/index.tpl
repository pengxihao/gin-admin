{{ define "content" }}
<html>
<h1>
    {{ .title }}
</h1>
<div>user page list</div>
    {{ range $u := .user }}
        <p>{{ $u.Name}}</p>
        <p>{{ $u.Email}}</p>
        <p>{{ $u.Mobile}}</p>
        <p>{{ $u.CreatedAt.Format "2006-01-02 15:04:05" }}</p>
        <p>{{ $u.UpdatedAt.Format "2006-01-02 15:04:05" }}</p>
    {{ end }}
</html>
{{ end }}