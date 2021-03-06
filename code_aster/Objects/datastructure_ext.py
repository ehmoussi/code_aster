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
:py:class:`DataStructure` --- Base of all objects
*************************************************
"""

import libaster
from libaster import DataStructure

from ..Utilities import deprecated, import_object, injector


@injector(DataStructure)
class ExtendedDataStructure(object):
    """This class defines the base class of the DataStructures.
    """
    # __getstate_manages_dict__ = 1
    cata_sdj = None
    ptr_class_sdj = None
    ptr_sdj = None

    orig_getName = DataStructure.getName

    def getName(self):
        """
            Overload standart getName() function to eliminate whitespace at both ends of the string.

            note: the c++ constructor adds automaticaly the whitespace when it creates a new object from the result name of this overloaded function getName.
        """
        return self.orig_getName().strip()

    def __getinitargs__(self):
        """Returns the argument required to reinitialize a derivated
        DataStructure object during unpickling.

        .. note:: This implementation does not satisfy any constructor of the
            base DataStructure. But most of the derivated class should have
            a constructor accepting the Jeveux name.
        """
        return (self.getName(), )

    def __getstate__(self):
        """Return internal state.

        Returns:
            list: Internal state.
        """
        return get_depends(self)

    def __setstate__(self, state):
        """Restore internal state.

        Arguments:
            state (list): Internal state.
        """
        set_depends(self, state)

    @property
    def sdj(self):
        """Return the DataStructure catalog."""
        if self.ptr_sdj is None:
            cata_sdj = getattr(self, 'cata_sdj', None)
            if not cata_sdj:
                 cata_sdj = DICT_SDJ.get(self.__class__.__name__)
            assert cata_sdj, ("The attribute 'cata_sdj' must be defined in "
                              "the class {}".format(self.__class__.__name__))
            if self.ptr_class_sdj is None:
                self.ptr_class_sdj = import_object("code_aster." + cata_sdj)
            self.ptr_sdj = self.ptr_class_sdj(nomj=self.getName())
        return self.ptr_sdj

    def use_count(self):
        """Return the number of reference to the DataStructure.

        Warning: Use only for debugging! Supported datastructures in
        ``PythonBindings/DebugInterface.cxx``.
        """
        return libaster.use_count(self)

    # transitional functions - to remove later
    @property
    @deprecated(case=1, help="Use 'getName()' instead.")
    def nom(self):
        return self.getName()


# This dictionnary avoids to add the DataStructure "_ext.py" file just
# to define the SD definition.
DICT_SDJ = {
    "CrackTip": "SD.sd_fond_fiss.sd_fond_fiss",
    "Crack": "SD.sd_fond_fissure.sd_fond_fissure",
    "DOFNumbering": "SD.sd_nume_ddl.sd_nume_ddl",
    "DynamicMacroElement": "SD.sd_macr_elem_dyna.sd_macr_elem_dyna",
    "HarmoGeneralizedResult": "SD.sd_dyna_gene.sd_dyna_gene",
    "Material": "SD.sd_mater.sd_mater",
}


class OnlyParallelObject:
    """This object is only available in parallel."""

    def __init__(self, *args, **kwargs):
        raise NameError("The object '{0}' is only available in parallel "
                        "executions.".format(self.__class__.__name__))


class PyDataStructure:
    """Temporary object used as a DataStructure during a Command execution."""

    def __init__(self, name="unnamed"):
        """Initialization"""
        self._name = name

    def getName(self):
        """Return the CO name."""
        return self._name

    @property
    def userName(self):
        """Same as 'getName'."""
        return self.getName()

    @userName.setter
    def userName(self, name):
        self._name = name

    def getType(self):
        """Return a type for syntax checking."""
        raise NotImplementedError("must be subclassed")


class AsInteger(PyDataStructure):
    """This class defines a simple integer used as a DataStructure."""

    @classmethod
    def getType(cls):
        return 'ENTIER'

class AsFloat(PyDataStructure):
    """This class defines a simple float used as a DataStructure."""

    @classmethod
    def getType(cls):
        return 'REEL'


def get_depends(obj):
    """Return dependencies as internal state.

    Arguments:
        obj (*DataStructure*): DataStructure object.

    Returns:
        list[*DataStructure*]: Number and list of dependencies.
    """
    return []
    # deps = obj.getDependencies()
    # state = [len(deps)] + deps
    # return state

def set_depends(obj, state):
    """Restore dependencies from internal state.

    Arguments:
        obj (*DataStructure*): DataStructure object.
        state (list): Number and list of dependencies.
    """
    return
    # nbdeps = state.pop(0)
    # for _ in range(nbdeps):
    #     obj.addDependency(state.pop(0))
