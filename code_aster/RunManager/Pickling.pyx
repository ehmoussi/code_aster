# coding: utf-8

# Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
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

import cPickle
import types
import traceback
import os.path as osp

from code_aster.Supervis.logger import logger
from code_aster.Supervis.libCommandSyntax cimport resultNaming


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

    def canRestart(self):
        """Tell if a restart is possible.
        This means that glob & pickled files are consistent."""
        if not osp.exists(self._base) or not osp.exists(self._filename):
            return False
        signPick = read_signature(self._filename)
        signBase = base_signature(self._base)
        if signPick != signBase:
            logger.warn("current base signature: {0}".format(signBase))
            logger.warn("pickled base signature: {0}".format(signPick))
            logger.warn("base and pickled objects are not consistent.")
            return False
        return True

    def save(self, delete=True):
        """Save objects of the context."""
        assert self._ctxt is not None, "context is required"
        ctxt = _filteringContext(self._ctxt)
        pick = open(self._filename, "wb")
        cPickle.dump( base_signature(self._base), pick, -1 )
        # ordered list of objects names
        objList = []
        for name, obj in ctxt.items():
            try:
                cPickle.dump( obj, pick, -1 )
            except TypeError:
                logger.warn("object can't be pickled: {0}".format(name))
                continue
            objList.append( name )
            # TODO should only delete Code_Aster objects, not all!
            if delete:
                del self._ctxt[name]
        # add management objects on the stack
        cPickle.dump( objList, pick, -1 )
        cPickle.dump( resultNaming.getLastId(), pick, -1 )
        pick.close()

    def load(self):
        """Load objects into the context"""
        assert self._ctxt is not None, "context is required"
        pick = open(self._filename, "rb")
        sign = cPickle.load( pick )
        # load all the objects
        objects = []
        try:
            while True:
                obj = cPickle.load( pick )
                objects.append( obj )
        except EOFError:
            # return management objects from the end of the end
            lastId = objects.pop()
            objList = objects.pop()
        pick.close()
        assert len(objects) == len(objList), (objects, objList)
        for name, obj in zip( objList, objects ):
            self._ctxt[name] = obj
        resultNaming.initCounter( lastId )


def _filteringContext(context):
    """Return a context by filtering the input objects by excluding:
    - modules,
    - code_aster objects,
    - ..."""
    ctxt = {}
    for name, obj in context.items():
        if ( name in ('code_aster', ) or name.startswith('__') or
             type(obj) in (types.ModuleType, types.ClassType, types.FunctionType) or
             issubclass(type(obj), types.TypeType) ):
            continue
        ctxt[name] = obj
    return ctxt

def read_signature(pickled):
    """Read the signature from the pickled file.
    The signature is stored in the first record."""
    sign = "unknown"
    try:
        with open(pickled, "rb") as pick:
            sign = cPickle.load( pick )
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
