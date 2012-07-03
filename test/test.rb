# This is a just a bootstrap effort to be replaced later with rspec or the like ...
# We assume in what follows that you've done the following already:
#
#    befog config --provider aws --key <your-key> --secret <your-secret>
#
# We further assume you have a 'developer' keypair already set up ...

`./bin/befog config befog-test --path test/.befog --provider aws --region us-east-1`
`./bin/befog config befog-test --path test/.befog --provider aws --image ami-86924def`
`./bin/befog config befog-test --path test/.befog --provider aws --image developer`

