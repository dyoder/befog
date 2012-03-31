Befog is a command line utility for cloud management. Or, put another way, it's a CLI wrapper for the `fog` gem.

For example, the following command would deploy 3 database servers to the `us-east-1` data center of the Amazon cloud:

    befog bank aws add --bank database --number 3 --region us-east-1

## Configuring Befog

In order to do anything interesting, you first need to tell Befog about your cloud accounts. You do this using the `configure` subcommand.

    befog configure aws --key <your-aws-key> --secret <your-aws-secret>
    
## Server Banks

Beyond the basic configuration for accessing an account, you'll want to set up options for *server banks* (groups of related servers, such a Web servers or database servers) and regions.

For example, the following command sets up the image to be used in the `us-east-1` region for database servers.

    befog configure aws --bank database --image <your-database-image> --region us-east-1
    
## Provisioning Servers

Once you have a configuration set up, you can easily provision new servers:

    befog bank aws add --bank database --number 3 --region us-east-1

You can also de-provision them just as easily:

    befog bank aws remove --bank database --number 2 --region us-east-1
    

## Other Features

You can suspend a bank:

    befog bank aws stop --group database
    
Or start them back up:

    befog bank aws start --group database
    
You can even run a command on every server in a bank:

    befog bank aws run --command 'apt-get install node'
    
## Limitations

Befog is currently still under development and only supports basic provisioning options for Amazon EC2.