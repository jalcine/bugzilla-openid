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
#  @date 04/23/12 9:46:53 AM
#
#
#-------------------------------------------------------------------------------

package Bugzilla::Extension::OpenID::Auth::Login;

use strict;
use Bugzilla;
use Bugzilla::Util;
use Cache::File;
use LWPx::ParanoidAgent;
use Net::OpenID::Consumer;
use base qw(Bugzilla::Auth::Login);

# TODO: Add support for creating accounts.
#use constant user_can_create_account => 1;

my $consumer = Net::OpenID::Consumer->new(
    ua              => LWPx::ParanoidAgent->new,
    cache           => Cache::File->new (
                        cache_root => '/tmp'
    ),
    args            => Bugzilla->cgi(),
    consumer_secret => "04ByswYpRSyAtw7Re4hN6kOdw5M34nyAAlLldk",
    required_root   => correct_urlbase()
);


sub get_login_info {
    my ($login_data) = @_;
    return ($login_data,
            $consumer->handle_server_response(
            not_openid => sub {
                return {};
            },
            setup_needed => sub {
                return {};
            },
            cancelled => sub {
                return {};
            },
            error => sub {
                return {};
            },
            verified => sub {
                my ($ident) = @_;

                return {
                    username => $ident->email,
                    password => "",
                    realname => $ident->fullname
                };
            }
        )
    );
}

1;
