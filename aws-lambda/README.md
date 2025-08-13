<center>
<h1>AWS Lambda App Config</h1>

Nuon Install Id: {{ .nuon.install.id }}

AWS Region: {{ .nuon.install_stack.outputs.region }}

</center>

### Create a record

```bash
curl --header Content-Type: application/json --request POST --data {"id":"7"} https://api.{{.nuon.install.sandbox.outputs.nuon_dns.public_domain.name}}/widgets
```

### Get a record

```bash
curl https://api.{{.nuon.install.sandbox.outputs.nuon_dns.public_domain.name}}/widgets/7
```

> This is under development

## Full State

<details>
<summary>Full Install State</summary>
<pre>{{ toPrettyJson .nuon }}</pre>
</details>

<center>

## Resources

[What is AWS Lambda?](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)

</center>
