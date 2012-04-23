# -*- Mode: perl; indent-tabs-mode: nil -*-
#
# The contents of this file are subject to the Mozilla Public
# License Version 1.1 (the "License"); you may not use this file
# except in compliance with the License. You may obtain a copy of
# the License at http://www.mozilla.org/MPL/
#
# Software distributed under the License is distributed on an "AS
# IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
# implied. See the License for the specific language governing
# rights and limitations under the License.
#
# The Original Code is the Bugzilla Bug Tracking System.
#
# The Initial Developer of the Original Code is Everything Solved, Inc.
# Portions created by the Initial Developers are Copyright (C) 2009 the
# Initial Developer. All Rights Reserved.
#
# Contributor(s):
#   Max Kanat-Alexander <mkanat@bugzilla.org>
#   Frédéric Buclin <LpSolit@gmail.com>

package Bugzilla::Extension::OpenID;
use strict;
use base qw(Bugzilla::Extension);

use Bugzilla::User;

# This is extensions/Example/lib/Util.pm. I can load this here in my
# Extension.pm only because I have a Config.pm.
#use Bugzilla::Extension::OpenID;

our $VERSION = '0.1';

sub attachment_process_data {
    my ($self, $args) = @_;
    my $type     = $args->{attributes}->{mimetype};
    my $filename = $args->{attributes}->{filename};

    # Make sure images have the correct extension.
    # Uncomment the two lines below to make this check effective.
    if ($type =~ /^image\/(\w+)$/) {
        my $format = $1;
        if ($filename =~ /^(.+)(:?\.[^\.]+)$/) {
            my $name = $1;
            #$args->{attributes}->{filename} = "${name}.$format";
        }
        else {
            # The file has no extension. We append it.
            #$args->{attributes}->{filename} .= ".$format";
        }
    }
}

sub auth_login_methods {
    my ($self, $args) = @_;
    my $modules = $args->{modules};
    if (exists $modules->{OpenID}) {
        $modules->{OpenID} = 'Bugzilla/Extension/OpenID/Auth/Login.pm';
    }
}

sub auth_verify_methods {
    my ($self, $args) = @_;
    my $modules = $args->{modules};
    if (exists $modules->{OpenID}) {
        $modules->{OpenID} = 'Bugzilla/Extension/OpenID/Auth/Verify.pm';
    }
}

sub config_add_panels {
    my ($self, $args) = @_;

    my $modules = $args->{panel_modules};
    $modules->{OpenID} = "Bugzilla::Extension::OpenID::Config";
}

sub config_modify_panels {
    my ($self, $args) = @_;

    my $panels = $args->{panels};

    # Add the "Example" auth methods.
    my $auth_params = $panels->{'auth'}->{params};
    my ($info_class)   = grep($_->{name} eq 'user_info_class', @$auth_params);
    my ($verify_class) = grep($_->{name} eq 'user_verify_class', @$auth_params);

    push(@{ $info_class->{choices} },   'OpenID');
    push(@{ $verify_class->{choices} }, 'OpenID');
}

# TODO: Devise a proper schema for OpenID.
sub db_schema_abstract_schema {
    my ($self, $args) = @_;
#    $args->{'schema'}->{'example_table'} = {
#        FIELDS => [
#            id       => {TYPE => 'SMALLSERIAL', NOTNULL => 1,
#                     PRIMARYKEY => 1},
#            for_key  => {TYPE => 'INT3', NOTNULL => 1,
#                           REFERENCES  => {TABLE  =>  'example_table2',
#                                           COLUMN =>  'id',
#                                           DELETE => 'CASCADE'}},
#            col_3    => {TYPE => 'varchar(64)', NOTNULL => 1},
#        ],
#        INDEXES => [
#            id_index_idx   => {FIELDS => ['col_3'], TYPE => 'UNIQUE'},
#            for_id_idx => ['for_key'],
#        ],
#    };
}

sub install_update_db {
    my $dbh = Bugzilla->dbh;
#    $dbh->bz_add_column('example', 'new_column',
#                        {TYPE => 'INT2', NOTNULL => 1, DEFAULT => 0});
#    $dbh->bz_add_index('example', 'example_new_column_idx', [qw(value)]);
}

# TODO: Devise a proper setup for user configuration.
sub user_preferences {
    my ($self, $args) = @_;
    my $tab = $args->{current_tab};
    my $save = $args->{save_changes};
    my $handled = $args->{handled};

    return unless $tab eq 'my_tab';

    my $value = Bugzilla->input_params->{'example_pref'};
    if ($save) {
        # Validate your data and update the DB accordingly.
        $value =~ s/\s+/:/g;
    }
    $args->{'vars'}->{example_pref} = $value;

    # Set the 'handled' scalar reference to true so that the caller
    # knows the panel name is valid and that an extension took care of it.
    $$handled = 1;
}

sub webservice {
    my ($self, $args) = @_;

    my $dispatch = $args->{dispatch};
    $dispatch->{Example} = "Bugzilla::Extension::Example::WebService";
}

sub webservice_error_codes {
    my ($self, $args) = @_;

    my $error_map = $args->{error_map};
    $error_map->{'example_my_error'} = 10001;
}

# This must be the last line of your extension.
__PACKAGE__->NAME;
