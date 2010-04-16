package Dist::Zilla::PluginBundle::PDONELAN;

# ABSTRACT: Dist::Zilla plugin bundle for PDONELAN

use Moose;
use Moose::Autobox;
with 'Dist::Zilla::Role::PluginBundle';

use Dist::Zilla::PluginBundle::Filter;
use Dist::Zilla::PluginBundle::Classic;
use Dist::Zilla::PluginBundle::Git;
use Dist::Zilla::Plugin::AutoPrereq;
use Dist::Zilla::Plugin::AutoVersion;
use Dist::Zilla::Plugin::CheckChangeLog;
use Dist::Zilla::Plugin::CheckChangesTests;
use Dist::Zilla::Plugin::CompileTests;
use Dist::Zilla::Plugin::DistManifestTests;
use Dist::Zilla::Plugin::HasVersionTests;
use Dist::Zilla::Plugin::ManifestSkip;
use Dist::Zilla::Plugin::MetaTests;
use Dist::Zilla::Plugin::MetaJSON;
use Dist::Zilla::Plugin::Repository;
use Dist::Zilla::Plugin::MetaResources;
use Dist::Zilla::Plugin::MinimumVersionTests;
use Dist::Zilla::Plugin::ModuleBuild;
use Dist::Zilla::Plugin::NextRelease;
use Dist::Zilla::Plugin::PodWeaver;
use Dist::Zilla::Plugin::PortabilityTests;
use Dist::Zilla::Plugin::Prepender;
use Dist::Zilla::Plugin::ReadmeFromPod;

sub bundle_config {
    my ( $self, $section ) = @_;
    my $class = ( ref $self ) || $self;

    my $arg = $section->{payload};

    my @plugins = Dist::Zilla::PluginBundle::Filter->bundle_config(
        {   name    => "$class/Classic",
            payload => {
                bundle => '@Classic',
                remove => [qw(PodVersion Readme Manifest)],
            }
        }
    );

    # params for AutoVersion
    my $major_version = defined $arg->{major_version} ? $arg->{major_version} : 1;

    my %meta_resources;
    for my $resource qw(homepage bugtracker repository license ratings) {
        $meta_resources{$resource} = $arg->{$resource} if defined $arg->{$resource};
    }

    # params

    my $prefix = 'Dist::Zilla::Plugin::';
    my @extra = map { [ "$class/$prefix$_->[0]" => "$prefix$_->[0]" => $_->[1] ] } (
        [ AutoPrereq          => { skip  => $arg->{auto_prereq_skip} } ],
        [ AutoVersion         => { major => $major_version } ],
        [ CheckChangeLog      => {} ],
        [ CheckChangesTests   => {} ],
        [ CompileTests        => {} ],
        [ HasVersionTests     => {} ],
        [ MetaTests           => {} ],
        [ MetaJSON            => {} ],
        [ Repository          => {} ],
        [ ManifestSkip        => {} ],
        [ MetaResources       => \%meta_resources ],
        [ MinimumVersionTests => {} ],
        [ ModuleBuild         => {} ],
        [ NextRelease         => {} ],
        [ PodWeaver           => {} ],
        [ PortabilityTests    => {} ],
        [ Prepender           => {} ],
        [ ReadmeFromPod       => {} ],
        [ Manifest            => {} ],   # should come last
    );

    push @plugins, @extra;

    # add git plugins
    push @plugins,
        Dist::Zilla::PluginBundle::Git->bundle_config(
        {   name    => "$section->{name}/Git",
            payload => {},
        }
        );

    eval "require $_->[1]; 1;" or die for @plugins;    ## no critic Carp

    return @plugins;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
__END__

=head1 DESCRIPTION

Putting the following in your dist.ini file:

    [@PDONELAN]

is equivalent to:

    [@Filter]
    bundle = @Classic
    remove = PodVersion
    remove = Readme
    remove = Manifest
      
    [AutoPrereq]
    [AutoVersion]
    [CheckChangeLog]
    [CheckChangesTests]
    [CompileTests]
    [DistManifestTests]
    [@Git]
    [HasVersionTests]
    [ManifestSkip]
    [MetaTests]
    [MetaJSON]
    [Repository]
    [MetaResources]
    [MinimumVersionTests]
    [ModuleBuild]
    [NextRelease]
    [PodWeaver]
    [PortabilityTests]
    [Prepender]
    [ReadmeFromPod]
    [Manifest]

You can specify the following options

    major_version = X ;; passed to AutoVersion (defaults to 1)
    auto_prereq_skip = ^Foo|Bar$
    
And also any of the following MetaResources

    homepage 
    bugtracker 
    repository ;; only needed if you want to overwrite [Repository]'s value
    license 
    ratings

=cut
