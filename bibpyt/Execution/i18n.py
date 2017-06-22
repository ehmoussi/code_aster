# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

# person_in_charge: mathieu.courtois at edf.fr

"""
Internationalization support for code_aster.
"""

import os
import os.path as osp
import gettext
import locale

from Noyau.N_utils import Singleton
from Noyau.N_types import force_list
from strfunc import get_encoding


def get_language():
    """Return default language (2 letters)"""
    lang = locale.getdefaultlocale()[0]
    if type(lang) is str:
        # support en-US or en_US
        lang = lang.split('_')[0].split('-')[0]
    else:
        lang = ""
    return lang


class Language(Singleton):

    """Simple class to switch between languages."""
    _singleton_id = 'i18n.Language'

    def __init__(self):
        """Initialization"""
        self.localedir = os.environ.get('ASTER_LOCALEDIR') or \
            osp.join(os.environ.get('ASTER_ROOT', ''), 'share', 'locale')
        self.domain = None
        self.current_lang = self.default_lang = get_language()

    def set_localedir(self, path):
        """Change the locale directory"""
        self.localedir = path

    def set_domain(self):
        """set the current domain"""
        self.domain = 'aster_messages'

    def get_current_settings(self):
        """Return the current language."""
        return self.current_lang, get_encoding()

    def install(self, lang=None):
        """Install the translation object for the given 'lang'."""
        if not self.domain:
            self.set_domain()
        lang = (lang or self.default_lang).lower()
        self.current_lang = lang
        if lang:
            lang = force_list(lang)
            low = lang[0].lower()
            lang.append(low)
            # add variants lang* (ex. en-UK, en-US...)
            try:
                variants = [i for i in os.listdir(self.localedir) \
                            if i.startswith(low)]
            except OSError:
                variants = []
            lang.extend(variants)
        tr = gettext.translation(
            self.domain, self.localedir, languages=lang, fallback=True)
        tr.install(unicode=True)
        return tr

localization = Language()
