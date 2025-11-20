{{ $region := .nuon.cloud_account.aws.region }}

<center>

[!inbox-zero](https://github.com/elie222/inbox-zero/raw/main/apps/web/app/opengraph-image.png)

<h1>Inbox Zero</h1>

<small>
{{ if .nuon.install_stack.outputs }} AWS | {{ dig "account_id" "000000000000" .nuon.install_stack.outputs }} |
{{ dig "region" "xx-vvvv-00" .nuon.install_stack.outputs }} |
{{ dig "vpc_id" "vpc-000000" .nuon.install_stack.outputs }} {{ else }} AWS | 000000000000 | xx-vvvv-00 | vpc-000000
{{ end }}
</small>

</center>

## Components

## Full State

Click "Manage > State"
