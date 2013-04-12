package Postfix::Mailgroups::Expand;
# ABSTRACT: Expand postfix mailgroups.

use 5.006;
use strict;
use warnings;

use File::Slurp;
use List::MoreUtils qw(uniq);
use Carp;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require AutoLoader;

our @ISA = qw(Exporter AutoLoader);
our @EXPORT = qw();

=head1 SYNOPSIS

	use Postfix::Mailgroups::Expand;
	
	my $groups = new Postfix::Mailgroups::Expand('groups'=>'/etc/postfix/virtual.groups','aliases'=>'/etc/postfix/aliases');

	$groups->write2dir('dirname');
						  

=method  my $groups = new Postfix::Mailgroups::Expand('groups'=>'/etc/postfix/virtual.groups','aliases'=>'/etc/postfix/aliases');

Create new object instance.
=cut

sub new {
	my $class = shift;
  my %passed_parms = @_;
	my $self  = {};
	$self->{exclude_addresses} = $passed_parms{'exclude_addresses'} || '^backup' ;
	$self->{exclude_groups} = $passed_parms{'exclude_groups'} || '^owner' ;
	bless($self, $class);
	$self->{ALIASES} = $self->_get_alias_maps($passed_parms{'aliases'});
	$self->{GROUPS} = $self->_get_virtual_alias_maps($passed_parms{'groups'});
	return $self;
}

=method $groups->write2dir($outdir);

Write expanded groups to $outdir.
=cut
sub write2dir{
	my ($self,$dir) = @_;

	my $groups = $self->{GROUPS};
	my $alias_map = $self->{ALIASES};

	if( ! -d $dir){
		mkdir($dir);
	}

	foreach my $k (keys %$groups) {
		my @adr = $self->_get_addresses($alias_map->{$groups->{$k}});
		write_file("$dir/$k",join("\n",@adr)."\n");
	}
}

=method $groups->_get_virtual_alias_maps($alias_file);

Return virtual aliases maps.
=cut
sub _get_virtual_alias_maps{
	my ($self,$filename) = @_;
	my $navrat;
	my @aliases = read_file($filename, chomp=>1);
	foreach my $line(@aliases){
  	if ($line =~ /^[^#]+.*@/) {
   	 my ($adr, $alias) = split(/\s/,$line);
		 $navrat->{$adr}=$alias;
		}
	}
	return $navrat;
}

=method $groups->_get_alias_maps($alias_file);

Return aliases maps.
=cut
sub _get_alias_maps{
	my ($self,$filename) = @_;
	my $navrat;
	my @aliases = read_file($filename, chomp=>1);
	foreach my $line(@aliases){
  	if ($line =~ /^[^#]+:include:/ and $line !~ /$self->{exclude_groups}/) {
   	 my ($adr, $alias) = split(/:.*:include:/,$line);
		 $navrat->{$adr}=$alias;
		}
	}
	return $navrat;
}

=method $groups->_get_addresses($filename);

Read addresses from file.
=cut
sub _get_addresses{
	my ($self,$filename) = @_;
	my @navrat;
	my @addresses = read_file($filename, chomp=>1);
	my @foo = map /$self->{exclude_addresses}/ ? () : $_, @addresses;
	foreach my $adr(@foo){
		if($self->{GROUPS}{$adr}){
			push(@navrat,$self->_get_addresses($self->{ALIASES}{$self->{GROUPS}{$adr}}));
		}else{
			push(@navrat,$adr);
		}
	}
	return sort uniq(@navrat);
}

1;
__END__

=head1 SEE ALSO

https://metacpan.org/module/Mail::ExpandAliases

=cut
1;
