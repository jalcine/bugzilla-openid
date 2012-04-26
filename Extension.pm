#-------------------------------------------------------------------------------
#
#   This file is part of Bugzilla-OpenID.
#
#   Copyright (C) 2012 Jacky Alciné <jackyalcine@gmail.com>
#
#   Bugzilla-OpenID is free software; you can redistribute it and/or
#   modify it under the terms of the GNU Library General Public
#   License as published by the Free Software Foundation; either
#   version 2 of the License, or (at your option) any later version.
#
#   Bugzilla-OpenID is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#   Library General Public License for more details.
#
#   You should have received a copy of the GNU Library General Public
#   License along with Bugzilla-OpenID.
#   If not, write to the Free Software Foundation, Inc.,
#   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#
#  @author Jacky Alciné <jackyalcine@gmail.com>
#  @date 04/23/12 9:41:00 AM
#
#
#-------------------------------------------------------------------------------

package Bugzilla::Extension::OpenID;
use strict;
use base qw(Bugzilla::Extension);

use Bugzilla::User;

our $VERSION = '0.1';

sub auth_login_methods {
    my ($self, $args) = @_;
    my $modules = $args->{modules};

    if (exists $modules->{OpenID}) {
        $modules->{OpenID} = 'Bugzilla/Extension/OpenID/Auth/Login.pm';
    }
}

sub config_add_panels {
    my ($self, $args) = @_;

    my $modules = $args->{panel_modules};
    $modules->{OpenID} = "Bugzilla::Extension::OpenID::Config";
}

# NOTE: Should OpenID provide verification schemes?
sub config_modify_panels {
    my ($self, $args) = @_;
    my $panels = $args->{'panels'};
    my $auth_panel_params = $panels->{'auth'}->{'params'};

    my ($user_info_class) =
                grep { $_->{'name'} eq 'user_info_class' } @$auth_panel_params;

    if ($user_info_class) {
        push(@{ $user_info_class->{'choices'} }, "OpenID,CGI");
    }
}

# TODO: Devise a proper schema for OpenID.
sub db_schema_abstract_schema {
    my ($self, $args) = @_;
    #$args->{'schema'}->{'OpenID'} = {};
}

# TODO: Devise a proper setup for user configuration.
sub user_preferences {
    my ($self, $args) = @_;
    my $tab = $args->{current_tab};
    my $save = $args->{save_changes};
    my $handled = $args->{handled};

    return unless $tab eq 'openid_tab';

    my $idUrl = Bugzilla->input_params->{'openid_pref_url'};
    if ($save) {
        # TODO: Add validation for valid Urls.
        $idUrl =~ s/\s+/:/g;
    }

    $args->{'vars'}->{openid_pref_url} = $idUrl;

    # Set the 'handled' scalar reference to true so that the caller
    # knows the panel name is valid and that an extension took care of it.
    $$handled = 1;
}

# TODO: In the future, provide a service permitting OpenID-based log-ins.
#sub webservice {
#    my ($self, $args) = @_;
#
#    my $dispatch = $args->{dispatch};
#    $dispatch->{OpenID} = "Bugzilla::Extension::OpenID::WebService";
#}

#sub webservice_error_codes {
#     my ($self, $args) = @_;
#
#     my $error_map = $args->{error_map};
#     $error_map->{'openid_general_error'} = 10001;
# }

# This must be the last line of your extension.
__PACKAGE__->NAME;
