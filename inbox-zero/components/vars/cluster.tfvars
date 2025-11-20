private_subnet_ids = [{{range $i, $subnet := .nuon.sandbox.outputs.vpc.private_subnet_ids}}{{if $i}}, {{end}}"{{$subnet}}"{{end}}]
