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

# person_in_charge: mathieu.courtois@edf.fr

"""
:py:mod:`outputs` --- Utilities for outputs on console
******************************************************

This module defines helper functions for outputs of code_aster.
"""

import os

import numpy

from .strfunc import convert


class CommandRepresentation(object):
    """Return a representation of a dict of an executed command with
    its keywords.

    Arguments:
        limit (int): Limits the output to the first occurrences of factor
            keywords or in the lists of values. Warning: Using *limit* may
            generate an invalid commands file.
        indent (int): Indentation of the first line.

    Attributes:
        _limit (int): Maximum number of occurrences for sequences.
        _limit_reached (bool): Tell if the limit has been reached at least once.
        _lines (list[str]): List of lines.
        _curline (list[str]): List of strings composing the current line.
        _indent (list[int]): Stack of indentation levels.
    """
    interrupt_value = '"_interrupt_MARK_value_"'
    interrupt_fact = '_interrupt_MARK_fact_()'

    def __init__(self, limit=0, indent=0):
        self._limit = limit
        self._limit_reached = False
        self._lines = []
        self._curline = []
        self._indent = [indent, ]

    def _newline(self):
        """Initialize a new line."""
        self._endline()
        self._curline.append(" " * self._indent[-1])

    def _endline(self):
        """Add the current line."""
        line = ''.join(self._curline).rstrip()
        if line != '':
            self._lines.append(line)
        self._curline = []

    def _add_indent(self):
        """Set the next indent spacing."""
        self._indent.append(len(''.join(self._curline)))

    def _reset_indent(self):
        """Revert indent spacing to its previous level."""
        self._indent.pop(-1)

    def get_text(self):
        """Return the text"""
        return os.linesep.join(self._lines)

    def repr_command(self, name, keywords, result):
        """Write the representation of a command.

        Arguments:
            name (str): Command name.
            keywords (dict): Dict of keywords.
            result (str): Name of the result.
        """
        self._newline()
        if result:
            self._curline.extend([result, " = "])
        self._curline.extend([name, "("])
        self._add_indent()
        self.repr_keywords(keywords)
        self._curline.append(")")
        self._reset_indent()
        self._endline()
        self._lines.append("")

    def repr_keywords(self, item, parent=None):
        """Write the representation of an object.

        Arguments:
            item (*misc*): Item to represent. It may be a *dict* of keywords,
                a sequence (*list* or *tuple*)...
        """
        if isinstance(item, dict):
            if parent is dict:
                self._curline.append("_F(")
                self._add_indent()

            keys = sorted(item.keys())
            for idx, key in enumerate(keys):
                obj = item[key]
                if obj is None:
                    continue
                self._curline.extend([key, "="])
                self.repr_keywords(obj, dict)
                self._print_delimiter(idx, keys, newline=True)

            if parent is dict:
                self._curline.append(")")
                self._reset_indent()

        elif isinstance(item, (list, tuple)):
            self.repr_sequence(item)
        else:
            self.repr_value(item)

    def repr_sequence(self, sequence):
        """Write the representation of sequence."""
        if len(sequence) > 1:
            self._curline.append("(")

        self._add_indent()
        for idx, item in enumerate(sequence):
            under_dict = isinstance(item, dict)
            if under_dict:
                self._curline.append("_F(")
                self._add_indent()

            self.repr_keywords(item, list)

            if under_dict:
                self._curline.append(")")
                self._reset_indent()

            if self._limited(idx, sequence, self.interrupt_value):
                break

            self._print_delimiter(idx, sequence, newline=under_dict)

        if len(sequence) > 1:
            self._curline.append(")")

        self._reset_indent()

    def repr_value(self, value):
        """Write the representation of a keyword value."""
        if isinstance(value, str):
            self._curline.append("{0!r}".format(convert(value)))
        elif hasattr(value, "getName"):
            if hasattr(value, 'value_repr'):
                self._curline.append(value.value_repr)
            elif value.userName:
                self._curline.append(value.userName)
            else:
                self._curline.append(decorate_name(value.getName()))
        elif isinstance(value, numpy.ndarray):
            self._curline.append("{0!r}".format(value))
        elif isinstance(value, (list, tuple)):
            self._curline.append('(')

            for idx, item in enumerate(value):
                self.repr_value(item)
                if self._limited(idx, value, self.interrupt_value):
                    break
                self._print_delimiter(idx, value)

            self._curline.append(")")
        else:
            self._curline.append("{0}".format(value))

    def _print_delimiter(self, idx, sequence, newline=False):
        if idx != len(sequence) - 1:
            self._curline.append(", ")
            if newline:
                self._newline()

    def _limited(self, idx, sequence, string):
        """Tell if the output must be limited."""
        if (self._limit <= 0 or idx < self._limit - 1
                or idx == len(sequence) - 1):
            return False
        self._limit_reached = True
        self._print_delimiter(0, [])
        self._curline.append(string)
        return True

    def end(self):
        """Close the export"""
        if self._limit_reached:
            self._curline.append(("\n# sequences have been limited to "
                "the first {0} occurrences.").format(self._limit))

    @classmethod
    def clean(cls, text):
        """Clean a text generated by *ExportToCommVisitor*."""
        text = text.replace(cls.interrupt_value, "...")
        text = text.replace(cls.interrupt_fact, "...")
        return text

def decorate_name(name):
    """Decorate a DataStructure's name.

    Arguments:
        name (str): Name of the object.
    """
    return convert("'<{0}>'".format(name.strip()))


def command_text(command_name, keywords, result="", limit=0):
    """Return a text representation of a command.

    Use ``limit=NN`` to limit the output to the fist ``NN`` occurrences in
    sequences.

    Arguments:
        command_name (str): Command name.
        keywords (dict): Dictionary of keywords.
        result (str): Name of the result.
        limit (int): If *limit* is a positive number, only the *limit* first
            occurrences are printed (default is 0, unlimited.

    Returns:
        str: String representation.
    """
    export = CommandRepresentation(limit)
    export.repr_command(command_name, keywords, result)
    export.end()

    text = export.get_text()
    text = export.clean(text)
    return text
