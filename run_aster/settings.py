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
:py:mod:`settings` --- Objects to deal with settings
----------------------------------------------------

:py:class:`Store` is a general storage object that holds various kinds
of settings as typed parameters.

This base object is the :py:class:`AbstractParameter` object from which are
derivated objects to store values of type *str*, *int*, *float*, *bool* and
list of *str*.
"""


from .logger import logger

DEPRECATED = "__DEPRECATED__"


class AbstractParameter:
    """An abstract parameter that must be subclassed to hold a typed value.

    Attributes:
        name (str): Parameter name.
        value (misc): Value of the parameter.
    """

    def __init__(self, name):
        self._name = name
        self._value = None

    @property
    def name(self):
        """str: Attribute that holds the 'name' property."""
        return self._name

    @property
    def value(self):
        """misc: Attribute that holds the 'value' property."""
        return self._value

    def convert(self, value):
        """Convert a value for the parameter type."""
        try:
            return self._convert(value)
        except (TypeError, ValueError) as exc:
            logger.error(f"Parameter '{self.name}': {exc}", exception=exc)

    def _convert(self, value):
        raise NotImplementedError("must be subclassed!")

    def set(self, value):
        """Convert and set the value.

        Arguments:
            value (misc): New value.
        """
        self._value = self.convert(value)

    @classmethod
    def factory(cls, store_typed_params, name):
        """Create a Parameter of the right type.

        Arguments:
            store_typed_params (dict): Dict of parameters supported by the
                :py:class:`Store` giving the excpected type.
            name (str): Parameter name.
        """
        typ = store_typed_params.get(name)
        if typ is None:
            logger.warning(f"unknown parameter: '{name}'")
            typ = "list[str]"
        if typ == DEPRECATED:
            typ = "str"
            return None
        klass = cls._typed_subclasses(typ)
        if not klass:
            raise TypeError(typ)
        return klass(name)

    @staticmethod
    def _typed_subclasses(typ):
        """Return the subclass for the expected type or *None* if not found."""
        return {
            "str": ParameterStr,
            "bool": ParameterBool,
            "int": ParameterInt,
            "float": ParameterFloat,
            "list[str]": ParameterListStr,
        }.get(typ)


class ParameterStr(AbstractParameter):
    """A parameter defined in a Export object of type string."""

    def _convert(self, value):
        if isinstance(value, (list, tuple)):
            value = " ".join([str(i) for i in value])
        return str(value)


class ParameterBool(AbstractParameter):
    """A parameter defined in a Export object of type boolean."""

    def _convert(self, value):
        if isinstance(value, (list, tuple)):
            value = " ".join([str(i) for i in value])
        if value == "":
            value = True
        elif value == "False":
            value = False
        return bool(value)


class ParameterInt(AbstractParameter):
    """A parameter defined in a Export object of type integer."""

    def _convert(self, value):
        if isinstance(value, (list, tuple)):
            value = " ".join([str(i) for i in value])
        return int(float(value))


class ParameterFloat(AbstractParameter):
    """A parameter defined in a Export object of type float."""

    def _convert(self, value):
        if isinstance(value, (list, tuple)):
            value = " ".join([str(i) for i in value])
        return float(value)


class ParameterListStr(AbstractParameter):
    """A parameter defined in a Export object of type list of strings."""

    def _convert(self, value):
        if not isinstance(value, (list, tuple)):
            value = [value]
        value = [str(i) for i in value]
        return value


class Store:
    """A base object to store some settings.

    This class must be subclassed and a `_new_param` class method must be added
    to make `set()` method usable.
    """

    def __init__(self):
        self._params = {}

    def __len__(self):
        """Return the storage size.

        Returns:
            int: Number of stored parameters.
        """
        return len(self._params)

    def add(self, param):
        """Add a parameter.

        Arguments:
            param (*Parameter*): Parameter object.
        """
        self._params[param.name] = param

    def has_param(self, name):
        """Tell if `name` is a known parameter.

        Arguments:
            name (str): Parameter name.

        Returns:
            bool: *True* it the parameter is defined, *False* otherwise.
        """
        return name in self._params

    def get_param(self, name):
        """Return a parameter.

        Arguments:
            name (str): Parameter name.

        Returns:
            misc: Parameter or *None* if the parameter does not exist.
        """
        return self._params.get(name)

    def get(self, name, default=None):
        """Return a parameter value.

        Arguments:
            name (str): Parameter name.
            default (misc, optional): Default value if the parameter does
                not exist.

        Returns:
            misc: Parameter value.
        """
        param = self.get_param(name)
        return (param and param.value) or default

    def set(self, name, value):
        """Automatically add a parameter of the expected type.

        Arguments:
            name (str): Parameter name.
            value (misc): Parameter value.
        """
        param = self._params.setdefault(name, self._new_param(name))
        if not param:
            del self._params[name]
            return
        param.set(value)

    @staticmethod
    def _new_param(name):
        """Create a Parameter of the right type."""
        return None
