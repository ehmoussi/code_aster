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

code_aster objects are saved and reloaded using the *pickle* protocol.

:func:`saveObjects` does the saving of objects available in the user context
(in which :func:`saveObjects` is called).
The command :func:`~code_aster.Commands.FIN` automatically calls this function.

Objects are reloaded by the function :func:`loadObjects` called just after the
Jeveux database has been reloaded by :func:`~code_aster.Commands.debut.init`
if the ``--continue`` argument is passed.
The command :func:`~code_aster.Commands.debut.POURSUITE` does also the same.
"""

import inspect
import os.path as osp
import pickle
import traceback
import types

import libaster

from ..Objects import DataStructure, ResultNaming
from ..Supervis import ExecutionParameter, logger


class Serializer(object):

    """This class manages 'save & reload' feature.

    Arguments:
        context (dict): The context to be saved or in which the loaded objects
            have to been set.

    Attributes:
        _ctxt (dict): Working context.
        _pick_filename (str): Filename of the pickle file.
        _base (str): Filename of the Jeveux database file.
        _sha_filename (str): Filename containing the SHA of the both previous
            files.
    """

    # TODO use repglob option?
    _sha_filename = "pick.code_aster.sha"
    _pick_filename = "pick.code_aster.objects"
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
        This means that glob & pickled files are consistent.

        Returns:
            bool: *True* if the previous execution can be continued.
        """
        if not (osp.exists(cls._base) and osp.exists(cls._pick_filename)
                and osp.exists(cls._sha_filename)):
            return False
        ref_pick, ref_base = read_signature(cls._sha_filename)
        sign_pick = file_signature(cls._pick_filename)
        if sign_pick != ref_pick:
            logger.error("Current pickled file: {0}".format(sign_pick))
            logger.error("Expected signature  : {0}".format(ref_pick))
            logger.error("The {0!r} file is not the expected one."
                         .format(cls._pick_filename))
            return False
        sign_base = file_signature(cls._base, 0, 8000000)
        if sign_base != ref_base:
            logger.error("Current base file : {0}".format(sign_base))
            logger.error("Expected signature: {0}".format(ref_base))
            logger.error("The {0!r} file is not the expected one."
                         .format(cls._base))
            return False
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
        with open(self._pick_filename, "wb") as pick:
            pickler = pickle.Pickler(pick)
            # ordered list of objects names
            logger.info("Saving objects...")
            objList = []
            for name, obj in ctxt.items():
                try:
                    logger.info("{0:<24s} {1}".format(name, type(obj)))
                    pickler.dump(obj)
                    objList.append(name)
                except (pickle.PicklingError, TypeError) as exc:
                    logger.warn("object can't be pickled: {0}".format(name))
                    logger.debug(str(exc))
                    continue
                if isinstance(obj, DataStructure):
                    saved.append(name)
            # add management objects on the stack
            pickler.dump(objList)
            pickler.dump(ResultNaming.getCurrentName())
        return saved

    def sign(self):
        """Sign the saved files and store their SHA signatures."""
        with open(self._sha_filename, "wb") as pick:
            pickler = pickle.Pickler(pick)
            sign_pick = file_signature(self._pick_filename)
            logger.info("Signature of pickled file   : {0}".format(sign_pick))
            sign_base = file_signature(self._base, 0, 8000000)
            logger.info("Signature of Jeveux database: {0}".format(sign_base))
            pickler.dump(sign_pick)
            pickler.dump(sign_base)

    def load(self):
        """Load objects into the context."""
        assert self._ctxt is not None, "context is required"
        with open(self._pick_filename, "rb") as pick:
            unpickler = pickle.Unpickler(pick)
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
        """Delete given objects from the initial context.

        Arguments:
            object_names (list[str]): List of object names to be removed from
                the context.
        """
        for name in object_names:
            self._ctxt[name] = None


def saveObjects(level=1, delete=True):
    """Save objects of the caller context in a file.

    Arguments:
        level (int): Number of frames to go back to find the user context.
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

    if ExecutionParameter().get_option("debug"):
        libaster.debugJeveuxContent("Saved jeveux objects:")

    pickler = Serializer(context)
    saved = pickler.save()
    # close Jeveux files (should not be done before pickling)
    libaster.finalize()
    pickler.sign()

    if delete:
        pickler.delete(saved)


def loadObjects(level=1):
    """Load objects from a file in the caller context.

    Arguments:
        level (int): Number of frames to go back to find the user context.
    """
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
    Serializer(context).load()


def _filteringContext(context):
    """Return a context by filtering the input objects by excluding:
    - modules,
    - code_aster objects,
    - ...

    Arguments:
        context (dict): Context to be filtered.

    Returns:
        dict: New cleaned context.
    """
    from ..Commands import CO, FIN
    ctxt = {}
    for name, obj in context.items():
        if name in ('code_aster', ) or name.startswith('__'):
            continue
        if obj in (CO, FIN):
            continue
        if type(obj) in (types.ModuleType, types.ClassType, types.MethodType):
            continue
        ctxt[name] = obj
    return ctxt


def read_signature(sha_file):
    """Read the signatures from the file containing the SHA strings.

    Arguments:
        sha_file (str): Filename of the pickled file to read.

    Returns:
        list[str]: List of the two signatures as SHA256 strings that identify
            the pickled file and the (first) Jeveux database file.
    """
    sign = []
    try:
        with open(sha_file, "rb") as pick:
            sign.append(pickle.Unpickler(pick).load())
            sign.append(pickle.Unpickler(pick).load())
    except (IOError, OSError):
        traceback.print_exc()
    logger.debug("pickled signatures: {0}".format(sign))
    return sign


def file_signature(filename, offset=0, bufsize=-1):
    """Compute a signature of the file.

    Arguments:
        filename (str): File to sign.
        offset (int): Offset before reading content (default to 0).
        bufsize (int): Size of the content to read (default to -1, content is
            read up to EOF).

    Returns:
        str: Signature as SHA256 string to identify the file.
    """
    from hashlib import sha256
    try:
        with open(filename, 'rb') as fobj:
            fobj.seek(offset, 0)
            sign = sha256(fobj.read(bufsize)).hexdigest()
    except (IOError, OSError):
        traceback.print_exc()
    return sign
