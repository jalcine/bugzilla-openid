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
use Bugzilla::Util;
use OpenID::Login;

sub get_page {
    my ($id) = @_;
    my $url = correct_urlbase();

    if ($id == "confirm"){
        $url += "/page.cgi?id=openid-redirect.html"
	} else if ($id == "handle"){
        $url += "/page.cgi?id=openid-auth.html"
	}

	return $url;
}

sub get_openid_auth_page {
    my ($claimedID) = @_;

    my $o = OpenID::Login->new(
        claimed_id => $claimedID,
        return_to  => get_page("auth")
    );
    return $o->get_auth_url();
}

sub get_login_info {
    my $cgi = cgi();
    my $o = OpenID::Login->new(
        cgi         => $cgi,
        return_to   => get_page("auth")
    );

    my $id = $o->verify_auth();

    if ($id){

    }
}

1;
