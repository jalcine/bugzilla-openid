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
#  @date 04/23/12 9:53:48 AM
#
#
#-------------------------------------------------------------------------------

package Bugzilla::Extension::OpenID::Util;
use strict;
use warnings;
use Bugzilla;
use base qw(Bugzilla::Auth::Login);

# There's three major phases; register, authenticate and add.
#
# register     - Registers a new OpenID account.
# authenticate - Handles the authentication work for OpenID.
# add          - Adds a OpenID identity to the user account.
#
# In order that redirects are properly setup, there's a redirection
# page that pushes the user to the needed location, and providing
# a bit more information about said redirection.
#
sub get_page {
    my ($page_id) = @_;
    my $url = correct_urlbase() + "/page.cgi?id=";

    switch ($page_id){
        case "handle_register":
            $url += "openid_continue.html&mode=register";
        break;

        case "handle_authenticate"
            $url += "openid_continue.html&mode=authenticate";
        break;

        case "handle_add"
            $url += "openid_continue.html&mode=add";
        break

        case "handle_add":
            $url += "openid_add.html";
        break;

        case "handle_register":
            $url += "openid_register.html";
        break;

        case "handle_authenticate"
            $url += "openid_authenticate.html";
        break;

        default:
            # TODO: Should we throw an error?
            $url = correct_urlbase();
        break;
    }

    return $url;
}

1;
