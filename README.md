Befog is a command line utility for cloud management. Or, put another way, it's a CLI wrapper for the `fog` gem.

Befog allows you to manage groups or clusters of servers as "banks."  A bank can have one or many servers.  
Features include the ability to start, stop, add to, remove, or run a command on all servers in a bank.

For example, the following command would add 3 servers to the server bank named `web-prod`:

    befog add web-prod --count 3

Befog tries to be helpful whenever a command is invoked with no arguments. You can start with this:

    befog
  
and go from there. For example, you can do:

    befog add
    
And you'll get this:

befog add <bank> [<options>]
	-c, --count COUNT       	The number of machines to provision (required) 
	-h, --help HELP         	Show this message                       
	-n, --name NAME         	The name of this configuration (default: default) 
	-p, --path PATH         	Path to the configuration file (default: ~/.befog) 
	-s, --spot SPOT         	Provision a spot instance               
	-t, --type TYPE         	The type of machines to provision       
	-u, --rehearse REHEARSE 	Dry-run, verbose logging, but don't actually run anything

## Configuring Befog

In order to do anything interesting, you first need to tell Befog about your cloud accounts. You do this using the `configure` subcommand.

    befog configure --provider aws --key <your-aws-key> --secret <your-aws-secret>
        
You also need to set up bank-specific configurations.

For example, the following command sets up the provider, region, image, and keypair to be used with the server bank named `web-prod` (you can also just say `config` for short):

    befog config web-prod --provider aws \
      --region us-east-1 --image <your-aws-image> \
      --keypair <your-keypair> --group <your-aws-group-name> \ 
      --type <your-aws-server-type>
    
To see the full list of configuration options, just type:

    befog config
    
You generally don't need to set these up very often - just when setting up a new bank, typically using a different region, provider, or image. Once a bank is configured, all servers deployed using that bank will use the bank's configuration automatically.
        
## Provisioning Servers

Once you have a configuration set up, you can easily provision new servers:

    befog add web-prod --count 3

You can also de-provision them just as easily:

    befog remove web-prod --count 3
    
## Multiple Configurations

Sometimes you want one set of servers for a test environment and another for production or a beta environment. You can use the `--name` option to specify a named configuration different environments. For example, let's start up the `web-prod` bank of our `test` environment:

    befog start web-prod --name test
    
Each environment must be configured separately. If you don't specify a name, the name `default` is applied. Again, once configured, you can typically use that configuration over and over.

Another option is to simply use different configuration files. You can do this with the --path command.

Finally, you can simply edit configurations directly if you want, since they are just YAML files and are fairly easy to read. Be careful, though, since this can confuse `befog` if the format get mangled somehow.

## Other Features

You can suspend a bank:

    befog stop web-prod
    
Or start them back up:

    befog start web-prod
    
You can even run a command on every server in a bank:

    befog run web-prod --command 'apt-get install redis'
    
You can get a list of all the servers associated with a bank:

    befog ls web-prod
    
or with a specific-provider:

    befog ls --provider aws
    
or for all servers currently deployed:

    befog ls
    
## Limitations

Befog is currently still under development and only supports basic provisioning options for Amazon EC2.
