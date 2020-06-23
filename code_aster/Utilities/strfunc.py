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

"""
:py:mod:`strfunc` --- String manipulations utilities
****************************************************

This module defines utilities functions for strings manipulation.
"""

import locale
import os

from .base_utils import force_list

_encoding = None


def get_encoding():
    """Return local encoding
    """
    global _encoding
    if _encoding is None:
        try:
            _encoding = locale.getpreferredencoding() or 'ascii'
        except locale.Error:
            _encoding = 'ascii'
    return _encoding


def to_unicode(string):
    """Try to convert string into a unicode string.

    Arguments:
        string (str): String to convert to unicode.

    Returns:
        str: Unicode string.
    """
    if type(string) is str:
        return string
    elif type(string) is dict:
        new = {}
        for k, v in list(string.items()):
            new[k] = to_unicode(v)
        return new
    elif type(string) is list:
        return [to_unicode(elt) for elt in string]
    elif type(string) is tuple:
        return tuple(to_unicode(list(string)))
    elif type(string) is not str:
        return string
    assert type(string) is str, "unsupported object: %s" % string
    for encoding in ('utf-8', 'iso-8859-15', 'cp1252'):
        try:
            s = str(string, encoding)
            return s
        except UnicodeDecodeError:
            pass
    return str(string, 'utf-8', 'replace')


def from_unicode(ustring, encoding, errors='replace'):
    """Try to encode a unicode string using encoding.

    Arguments:
        ustring (str): Unicode string to encode.
        encoding (str): Encoding name.
        errors (str): Behaviour in case of encoding error
            (see :py:func:`string.encode`).

    Returns:
        str: Encoded string.
    """
    try:
        return ustring.encode(encoding)
    except UnicodeError:
        pass
    return ustring.encode(encoding, errors)


def convert(content, encoding=None, errors='replace'):
    """Convert content using encoding or default encoding if *None*.

    Arguments:
        content (str/unicode): Text to convert.
        encoding (str): Encoding name.
        errors (str): Behaviour in case of encoding error
            (see :meth:`string.encode`).

    Returns:
        str: Encoded string.
    """
    if type(content) is not str:
        content = str(content)
    if type(content) == str:
        content = to_unicode(content)
    return content


def ufmt(uformat, *args):
    """Helper function to format a string by converting all its arguments to unicode"""
    if type(uformat) is not str:
        uformat = to_unicode(uformat)
    if len(args) == 1 and type(args[0]) is dict:
        arguments = to_unicode(args[0])
    else:
        nargs = []
        for arg in args:
            if type(arg) in (str, str, list, tuple, dict):
                nargs.append(to_unicode(arg))
            elif type(arg) not in (int, int, float):
                nargs.append(to_unicode(str(arg)))
            else:
                nargs.append(arg)
        arguments = tuple(nargs)
    try:
        formatted_string = uformat % arguments
    except UnicodeDecodeError as err:
        print(type(uformat), uformat)
        print(type(arguments), arguments)
        raise
    return formatted_string


def clean_string(chaine):
    """Supprime tous les caractères non imprimables.
    """
    invalid = '?'
    txt = []
    for char in chaine:
        if ord(char) != 0:
            txt.append(char)
        else:
            txt.append(invalid)
    return ''.join(txt)


def cut_long_lines(txt, maxlen, sep=os.linesep,
                   l_separ=(' ', ',', ';', '.', ':')):
    """Coupe les morceaux de `txt` (isolés avec `sep`) de plus de `maxlen`
    caractères.
    On utilise successivement les séparateurs de `l_separ`.
    """
    l_lines = txt.split(sep)
    newlines = []
    for line in l_lines:
        if len(line) > maxlen:
            l_sep = list(l_separ)
            if len(l_sep) == 0:
                newlines.extend(force_split(line, maxlen))
                continue
            else:
                line = cut_long_lines(line, maxlen, l_sep[0], l_sep[1:])
                line = maximize_lines(line, maxlen, l_sep[0])
            newlines.extend(line)
        else:
            newlines.append(line)
    # au plus haut niveau, on assemble le texte
    if sep == os.linesep:
        newlines = os.linesep.join(newlines)
    return newlines


def maximize_lines(l_fields, maxlen, sep):
    """Construit des lignes dont la longueur est au plus de `maxlen` caractères.
    Les champs sont assemblés avec le séparateur `sep`.
    """
    newlines = []
    if len(l_fields) == 0:
        return newlines
    # ceinture
    assert max([len(f)
               for f in l_fields]) <= maxlen, 'lignes trop longues : %s' % l_fields
    while len(l_fields) > 0:
        cur = []
        while len(l_fields) > 0 and len(sep.join(cur + [l_fields[0], ])) <= maxlen:
            cur.append(l_fields.pop(0))
        # bretelle
        assert len(cur) > 0, l_fields
        newlines.append(sep.join(cur))
    newlines = [l for l in newlines if l != '']
    return newlines


def force_split(txt, maxlen):
    """Force le découpage de la ligne à 'maxlen' caractères.
    """
    l_res = []
    while len(txt) > maxlen:
        l_res.append(txt[:maxlen])
        txt = txt[maxlen:]
    l_res.append(txt)
    return l_res


def copy_text_to(text, files):
    """Print a message into one or more files.

    Files may be filenames (as string) or file-object.

    Arguments:
        text (str): Message to be printed
        files (str|file, list[str|file]): Filename(s) or file-object(s)
    """
    def _dump(fobj):
        fobj.write(text)
        fobj.write(os.linesep)
        fobj.flush()

    files = force_list(files)
    for f_i in files:
        if isinstance(f_i, str):
            with open(f_i, 'a') as obj:
                _dump(obj)
        else:
            _dump(f_i)


def _splitline(line, maxlen):
    """Return a list of lines with a length <= `maxlen`"""
    line = line.strip()
    if len(line) <= maxlen:
        return [line]
    lines = []
    for sep in " ,;:/":
        try:
            last = line.rindex(sep)
        except ValueError:
            last = 0
    if last > 0:
        lines.extend(_splitline(line[:last], maxlen))
        lines.extend(_splitline(line[last:], maxlen))
    else:
        lines.append(line[:maxlen])
        lines.extend(_splitline(line[maxlen:], maxlen))
    return lines

def _fixed_length(lines ,maxlen):
    """Fix lines length at `maxlen`."""
    fmt = "{{0:{}s}}".format(maxlen)
    return [fmt.format(line) for line in lines]

def textbox(text, maxlen=80):
    """Format a text into a box to be highlighted.
    """
    upleft = chr(0x2554)
    upright = chr(0x2557)
    horiz = chr(0x2550)
    vert = chr(0x2551)
    botleft = chr(0x255a)
    botright = chr(0x255d)
    head = " " + upleft + horiz * (maxlen + 2) + upright
    foot = " " + botleft + horiz * (maxlen + 2) + botright
    fmt = " " + vert + " {0} " + vert
    lines = ["", head]
    splitted = []
    for line in text.splitlines():
        splitted.extend(_splitline(line, maxlen))
    fixed = _fixed_length(splitted, maxlen)
    lines.extend([fmt.format(line) for line in fixed])
    lines.extend([foot, ""])
    return os.linesep.join(lines)
