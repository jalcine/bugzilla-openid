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
use base qw(Bugzilla::Auth::Login);
use constant user_can_create_account => 1;
use Bugzilla;

use Bugzilla::Constants;
use Cache::File;
use LWPx::ParanoidAgent;
use Net::OpenID::Consumer;

# Build the consumer that we'll use.
$consumer = Net::OpenID::Consumer->new(
    ua    => LWPx::ParanoidAgent->new,
    cache => Cache::File->new( cache_root => '/tmp/mycache' ),
    args  => Bugzilla::$cgi,
    required_root => $installBasePath,
    assoc_options => [
        max_encrypt => 1,
        session_no_encrypt_https => 1,
    ],
);

sub connect_to_openid_server {
    my $failure = { failure => AUTH_NODATA };

    my $claimedID = $consumer->claimed_identify( $user_Url );
    unless ($claimedID)
        return $failure;

    my $checkClaimedID = $claimedID->check_url(
        return_to      => $confirmationPage,
        trust_root     => $baseRoot,
        delayed_return => 1
    );
}

sub get_login_info {
    return $csr->handle_server_response(
        not_openid => sub {
            # TODO: Return BZ_OPENID_LOGIN_INVALID
            return 0;
        },
        setup_needed => sub {
            # TODO: Return BZ_OPENID_LOGIN_SETUP
            return 0;
        },
        cancelled => sub {
            # TODO: Return BZ_OPENID_LOGIN_CANCELLED
            # TODO: Should fall back to classic authentication.
            return 0;
        },
        verified => sub {
            # TODO: Return BZ_OPENID_LOGIN_SUCCESS
            my ($vident) = @_;
            my $url = $vident->url;
        },
        error => sub {
            # TODO: Return BZ_OPENID_LOGIN_ERROR
            my ($errcode,$errtext) = @_;
            die("Error validating identity: $errcode: $errcode");
        },
    );
}

1;
