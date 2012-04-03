Befog is a command line utility for cloud management. Or, put another way, it's a CLI wrapper for the `fog` gem.

Befog allows you to manage groups or clusters of servers as "banks."  A bank can have one or many servers.  
Features include the ability to start, stop, add to, remove, or run a command on all servers in a bank.

For example, the following command would add 3 servers to the server bank named `database`:

    befog add database --count 3
    
Befog provides some basic help whenever a command is invoked with no arguments. You can start with this:

    befog
  
and go from there. For example, you can do:

    befog add
    
And you'll get this:

    Usage: befog add <bank> [options]
        -n, --number NUMBER              The number of machines to provision
        -p, --path PATH                  Path to the configuration file you want to use (defaults to '~/.befog')
            --name NAME                  The name of this configuration (defaults to 'default')
        -h, --help                       Show this message

## Configuring Befog

In order to do anything interesting, you first need to tell Befog about your cloud accounts. You do this using the `configure` subcommand.

    befog configure --provider aws --key <your-aws-key> --secret <your-aws-secret>
        
You also need to set up bank-specific configurations.

For example, the following command sets up the provider, region, image, and keypair to be used with the server bank named `database`:

    befog configure database --provider aws \
      --region us-east-1 --image <your-database-image> \
      --keypair <your-keypair>
    
To see the full list of configuration options, just type:

    befog configure
    
You generally don't need to set these up very often - just when setting up a new bank, typically using a different region, provider, or image. Once a bank is configured, all servers deployed using that bank will use the bank's configuration automatically.
        
## Provisioning Servers

Once you have a configuration set up, you can easily provision new servers:

    befog add database --count 3

You can also de-provision them just as easily:

    befog remove database --count 3
    
## Multiple Configurations

Sometimes you want one set of servers for a test environment and another for production or a beta environment. You can use the `--environment` option to handle different environments. For example, let's start up the database bank of our `test` environment:

    befog start database --e test
    
Each environment must be configured separately. Again, once configured, you can typically use that configuration over and over.

Another option is to simply use different configuration files. You can do this with the --path command.

Finally, you can simply edit configurations directly if you want, since they are just YAML files and are fairly easy to read. Be careful, though, since this can confuse `befog` if the format get mangled somehow.

## Other Features

You can suspend a bank:

    befog stop database
    
Or start them back up:

    befog start database
    
You can even run a command on every server in a bank:

    befog run database --command 'apt-get install redis'
    
You can get a list of all the servers associated with a bank:

    befog ls database
    
or with a specific-provider:

    befog ls --provider aws
    
or for all servers currently deployed:

    befog ls
    
## Limitations

Befog is currently still under development and only supports basic provisioning options for Amazon EC2.
