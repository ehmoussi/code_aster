# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

from .i18n import translate as _

# aster_pkginfo will only be available after installation
try:
    from .aster_pkginfo import version_info
except ImportError:
    version_info = ()


def get_version():
    """Return the version number as string"""
    return '.'.join(str(i) for i in version_info.version)

def get_version_name():
    """Return the 'name' of the version.
    - testing or stable for a frozen version,
    - stable-updates or unstable
    """
    sta = version_info.version[-1] == 0
    expl = version_info.branch.startswith('v')
    if expl:
        return 'stable' if sta else 'stable-updates'
    else:
        return 'testing' if sta else 'unstable'

def get_version_desc():
    """Return the description of the version"""
    name = get_version_name()
    # can not be global because of the translation system (``_`` not
    # yet installed by gettext)
    names = {
        'stable' : _("EXPLOITATION (stable)"),
        'stable-updates' : _("CORRECTIVE AVANT STABILISATION (stable-updates)"),
        'testing' : _("DÉVELOPPEMENT STABILISÉE (testing)"),
        'unstable' : _("DÉVELOPPEMENT (unstable)"),
    }
    return names.get(name, _("DÉVELOPPEMENT (%s)") % name)
