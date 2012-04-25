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
use base qw(Bugzilla::Auth::Login);
use constant user_can_create_account => 1;
use OpenID::Login;

my $o = undef;
my $cgi = Bugzilla::cgi();
my $id = undef;

sub get_openid_auth_page {
    my ($claimedID) = @_;

    $o = OpenID::Login->new(
        claimed_id => $claimedID,
        return_to  => correct_urlbase() + "/page.cgi?id=openid-auth.html"
    );

    return $o->get_auth_url();
}

sub get_login_info {
    $o = OpenID::Login->new(
        cgi         => $cgi,
        return_to   => correct_urlbase() + "/page.cgi?id=openid-verify.html"
    );

    $id = $o->verify_auth();

    if ($id){
        # TODO: Handle the authentication.
        print $id;
    }

    return 0;
}

sub fail_nodata {
    return 0;
}

1;
