package main

import (
	"fmt"

	"github.com/pulumi/pulumi-cloudflare/sdk/v3/go/cloudflare"
	"github.com/pulumi/pulumi-digitalocean/sdk/v4/go/digitalocean"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {

		for i := 0; i < 3; i++ {
			dropletName := "control-plane-" + fmt.Sprint(i)
			droplet, err := digitalocean.NewDroplet(ctx, dropletName, &digitalocean.DropletArgs{
				Image:   pulumi.String("87607619"),
				Region:  pulumi.String("fra1"),
				Size:    pulumi.String("s-2vcpu-4gb"),
				SshKeys: pulumi.ToStringArray([]string{"30756593"}),
			})
			if err != nil {
				return err
			}

			ctx.Export(dropletName, droplet.Ipv4Address)

			dnsName := "talosDNS-" + fmt.Sprint(i)
			_, err = cloudflare.NewRecord(ctx, dnsName, &cloudflare.RecordArgs{
				Name:   pulumi.String("talos"),
				ZoneId: pulumi.String("5135e0adad7dabaa3699abac5bba8559"),
				Type:   pulumi.String("A"),
				Value:  pulumi.StringOutput(droplet.Ipv4Address),
				Ttl:    pulumi.Int(3600),
			})
			if err != nil {
				return err
			}
		}

		return nil
	})
}
