# coding: utf-8

# Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

"""
:py:mod:`Pickling` --- Serialization of code_aster objects
**********************************************************

.. note:: Currently not work at all! To be completely reviewed.

"""

import inspect
import os.path as osp
import pickle
import traceback
import types

import libaster

from ..Objects import DataStructure, ResultNaming
from ..Supervis import ExecutionParameter, logger


class Pickler(object):

    """This class manages 'save & reload' feature."""

    # TODO use repglob option?
    _filename = "code_aster.pick"
    _base = "glob.1"

    def __init__(self, context=None):
        """Initialization
        :param context: context to save or in which loading objects
        :type context: dict
        """
        self._ctxt = context

    @classmethod
    def canRestart(cls):
        """Tell if a restart is possible.
        This means that glob & pickled files are consistent."""
        if not osp.exists(cls._base) or not osp.exists(cls._filename):
            return False
        signPick = read_signature(cls._filename)
        signBase = base_signature(cls._base)
        if signPick != signBase:
            logger.warn("current base signature: {0}".format(signBase))
            logger.warn("pickled base signature: {0}".format(signPick))
            logger.warn("base and pickled objects are not consistent.")
            # FIXME return False
        return True

    def save(self):
        """Save objects of the context.

        Returns:
            list[str]: List of the names of the DataStructure objects actually
            saved.
        """
        assert self._ctxt is not None, "context is required"
        ctxt = _filteringContext(self._ctxt)
        saved = []
        with open(self._filename, "wb") as pick:
            pickler = pickle.Pickler(pick)
            pickler.dump(base_signature(self._base))
            # ordered list of objects names
            logger.info("Saving objects...")
            objList = []
            for name, obj in ctxt.items():
                try:
                    logger.info("{0:<24s} {1}".format(name, type(obj)))
                    pickler.dump(obj)
                    objList.append(name)
                except (pickle.PicklingError, TypeError):
                    logger.warn("object can't be pickled: {0}".format(name))
                    continue
                if isinstance(obj, DataStructure):
                    saved.append(name)
            # add management objects on the stack
            pickler.dump(objList)
            pickler.dump(ResultNaming.getCurrentName())
        return saved

    def load(self):
        """Load objects into the context"""
        assert self._ctxt is not None, "context is required"
        with open(self._filename, "rb") as pick:
            unpickler = pickle.Unpickler(pick)
            sign = unpickler.load()
            # load all the objects
            objects = []
            try:
                while True:
                    obj = unpickler.load()
                    objects.append(obj)
            except EOFError:
                # return management objects from the end of the end
                lastId = int(objects.pop(), 16)
                objList = objects.pop()
            pick.close()
            assert len(objects) == len(objList), (objects, objList)
            logger.info("Restored objects:")
            for name, obj in zip(objList, objects):
                self._ctxt[name] = obj
                logger.info("{0:<24s} {1}".format(name, type(obj)))
            # restore the objects counter
            ResultNaming.initCounter(lastId)

    def delete(self, object_names):
        """Delete given objects from the initial context."""
        for name in object_names:
            self._ctxt[name] = None


def saveObjects(level=1, delete=True):
    """Save objects of the caller context in a file.

    Arguments:
        delete (bool): If *True* the saved objects are deleted from the context.
    """
    caller = inspect.currentframe()
    for i in range(level):
        caller = caller.f_back
    try:
        context = caller.f_globals
        logger.debug("frame saved: {0}".format(context['__name__']))
    finally:
        del caller

    pickler = Pickler(context)
    saved = pickler.save()
    # close Jeveux files (should not be done before pickling)
    if ExecutionParameter().get_option("debug"):
        libaster.debugJeveuxContent("Saved jeveux objects:")
    libaster.finalize()
    if delete:
        pickler.delete(saved)


def loadObjects(level=1):
    """Load objects from a file in the caller context"""
    caller = inspect.currentframe()
    for i in range(level):
        caller = caller.f_back
    try:
        context = caller.f_globals
        logger.debug("load objects in frame: {0}".format(context['__name__']))
    finally:
        del caller
    if ExecutionParameter().get_option("debug"):
        libaster.debugJeveuxContent("Reloaded jeveux objects:")
    Pickler(context).load()


def _filteringContext(context):
    """Return a context by filtering the input objects by excluding:
    - modules,
    - code_aster objects,
    - ..."""
    ctxt = {}
    for name, obj in context.items():
        if name in ('code_aster', ) or name.startswith('__'):
            continue
        if type(obj) in (types.ModuleType, types.ClassType, types.MethodType):
            continue
        ctxt[name] = obj
    return ctxt


def read_signature(pickled):
    """Read the signature from the pickled file.
    The signature is stored in the first record."""
    sign = "unknown"
    try:
        with open(pickled, "rb") as pick:
            sign = pickle.Unpickler(pick).load()
    except (IOError, OSError):
        traceback.print_exc()
    logger.debug("pickled signature: {0}".format(sign))
    return sign


def base_signature(filename):
    """Compute a signature of an execution. The file must not be opened."""
    from hashlib import sha256
    bufsize = 100000 * 8 * 10    # 10 records of standard size
    offset = 0
    sign = 'not available'
    try:
        with open(filename, 'rb') as fobj:
            fobj.seek(offset, 0)
            sign = sha256(fobj.read(bufsize)).hexdigest()
    except (IOError, OSError):
        traceback.print_exc()
    logger.debug("results database signature: {0}".format(sign))
    return sign
