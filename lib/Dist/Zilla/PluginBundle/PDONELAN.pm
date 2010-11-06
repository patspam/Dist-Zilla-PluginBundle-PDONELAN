package Dist::Zilla::PluginBundle::PDONELAN;

# ABSTRACT: Dist::Zilla pre-wired for PDONELAN

=head1 DESCRIPTION

This is a Dist::Zilla plugin bundle.

Please see the (nicely commented) source code to see which plugins
this module bundles - I already have to list them twice in the source
just to make this work - three times would drive me nuts.

=cut

use Moose;
with 'Dist::Zilla::Role::PluginBundle::Easy';

# Explicitly list other PluginBundles as dependencies
use Dist::Zilla::PluginBundle::Basic;
use Dist::Zilla::PluginBundle::Git;

# Explicitly list out all plugins not covered by the above PluginBundles as dependencies
use Dist::Zilla::Plugin::MetaJSON;
use Dist::Zilla::Plugin::ReadmeFromPod;
use Dist::Zilla::Plugin::EOLTests;
use Dist::Zilla::Plugin::PodCoverageTests;
use Dist::Zilla::Plugin::PodSyntaxTests;
use Dist::Zilla::Plugin::PortabilityTests;
use Dist::Zilla::Plugin::CompileTests;
use Dist::Zilla::Plugin::PkgVersion;
use Dist::Zilla::Plugin::PodWeaver;
use Dist::Zilla::Plugin::NextRelease;
use Dist::Zilla::Plugin::AutoPrereqs;
use Dist::Zilla::Plugin::MinimumPerl;
use Dist::Zilla::Plugin::Git::NextVersion;
use Dist::Zilla::Plugin::GithubMeta;
use Dist::Zilla::Plugin::MetaConfig;
use Dist::Zilla::Plugin::CheckChangeLog;
use Dist::Zilla::Plugin::CheckChangesHasContent;
use Dist::Zilla::Plugin::UpdateGitHub;

=method configure

Adds the list of plugins (and bundles) in order

=cut

sub configure {
    my ($self) = @_;

    # Plugins are listed in terms of dzil phases
    # See: L<Dist::Zilla::Dist::Builder::build_in>

    # All non-bundle plugins listed should also have a corresponding
    # "use Dist::Zilla::Plugin::X" line for dependency resolution

    $self->add_bundle('Git');    # @RJBS
    $self->add_plugins(

        # FileGatherer
        'GatherDir',             # @Basic
        'MetaYAML',              # @Basic
        'ExecDir',               # @Basic
        'ShareDir',              # @Basic
        'License',               # @Basic
        'MetaJSON',              # @RJBS
        'ReadmeFromPod',         # @AVAR
        'EOLTests',              # @FLORA
        'PodCoverageTests',      # @FLORA
        'PodSyntaxTests',        # @RJBS
        'PortabilityTests',      # @DAGOLDEN
        'CompileTests',          # @MARCEL
        'Manifest',              # @Basic    This one wants to come last

        # FilePruner
        'PruneCruft',            # @Basic
        'ManifestSkip',          # @Basic

        # FileMunger
        'ExtraTests',            # @Basic
        'PkgVersion',            # @RJBS
        'PodWeaver',             # @RJBS
        'NextRelease',           # @RJBS

        # PrereqSource
        'AutoPrereqs',           # @RJBS
        'MinimumPerl',           # @DAGOLDEN

        # MetaProvider
        'Git::NextVersion',      # V=1.000 dzil release, dzil release --trial
        'GithubMeta',            # repository.{url, web, type}, homepage instead of 'MetaResources' or 'Repository'
        [
            Bugtracker =>        # bugtracker.{web, mailto} instead of 'MetaResources'
              { web => 'http://github.com/pdonelan/%s/issues' }
        ],

        'MetaConfig',            # @RJBS

        # InstallTool
        'MakeMaker',             # @Basic
        'CheckChangeLog',        # @MARCEL

        # BeforeRelease
        'CheckChangesHasContent',    # @DAGOLDEN
        'TestRelease',               # @Basic
        'ConfirmRelease',            # @Basic

        # Releaser
        'UploadToCPAN',              # @Basic
        'UpdateGitHub',              # @ROKR
    );
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
