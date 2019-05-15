# coding: utf-8

# Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

# person_in_charge: nicolas.sellenet@edf.fr

from ..Objects import GenericMechanicalLoad
from .affe_modele import AFFE_MODELE
from .ExecuteCommand import ExecuteCommand
from ..Cata.Language.SyntaxObjects import FactorKeyword


class MechanicalLoadDefinition(ExecuteCommand):
    
    """Command that defines :class:`~code_aster.Objects.GenericMechanicalLoad`.
    """
    command_name = "AFFE_CHAR_MECA"
    neumannLoads = ['PESANTEUR', 'ROTATION', 'FORCE_FACE', 'FORCE_ARETE', 'FORCE_CONTOUR', 'FORCE_INTERNE', 'PRE_SIGM', 'PRES_REP', 'EFFE_FOND', 'PRE_EPSI', 'FORCE_POUTRE', \
                    'FORCE_TUYAU', 'FORCE_COQUE', 'FORCE_ELEC', 'INTE_ELEC', 'VITE_FACE', 'ONDE_FLUI', 'FLUX_THM_REP', 'FORCE_SOL', 'FORCE_NODALE', 'EVOL_CHAR', 'VECT_ASSE']
    dirichletLoads = ['DDL_IMPO', 'DDL_POUTRE', 'FACE_IMPO', 'CHAMNO_IMPO', 'ARETE_IMPO', 'LIAISON_DDL', 'LIAISON_OBLIQUE', 'LIAISON_GROUP', 'LIAISON_MAIL', 'LIAISON_PROJ', \
                      'LIAISON_CYCL', 'LIAISON_SOLIDE', 'LIAISON_ELEM', 'LIAISON_UNIF', 'LIAISON_CHAMNO', 'LIAISON_RBE3', 'LIAISON_INTERF', 'LIAISON_COQUE', \
                      'RELA_CINE_BP', 'IMPE_FACE']
    def _getNodeGroups(self, keywords):
        """for parallel load, return all node groups present in AFFE_CHAR_MECA, in order to define the partial mesh
        """
        load_types = [key for key in list(self._cata.keywords.keys()) if isinstance(self._cata.keywords[key], FactorKeyword)]
        nodeGroups = set()
        for key in list(keywords.keys()):
            if key in ("LIAISON_DDL", "DDL_IMPO", "LIAISON_OBLIQUE", "LIAISON_UNIF", "LIAISON_SOLIDE", "DDL_POUTRE"):
                for mcf in keywords[key]:
                    mc = mcf.get("GROUP_NO")
                    if mc:
                        nodeGroups.update(mc)
                    else:
                        raise NotImplementedError("Only GROUP_NO is accepted in parallel AFFE_CHAR_MECA")
            elif key=="LIAISON_GROUP":
                for mcf in keywords[key]:
                    mc1 = mcf.get("GROUP_NO_1")
                    mc2 = mcf.get("GROUP_NO_2")
                    if mc1 and mc2:
                        nodeGroups.update(mc1)
                        nodeGroups.update(mc2)
                    else:
                        raise NotImplementedError("Only GROUP_NO_1 and GROUP_NO_2 are accepted in parallel AFFE_CHAR_MECA")
            elif key=="LIAISON_RBE3":
                for mcf in keywords[key]:
                    nodeGroups.add(mcf["GROUP_NO_MAIT"])
                    nodeGroups.update(mcf["GROUP_NO_ESCL"])
            elif key in load_types:
                raise NotImplementedError("Type of load {0!r} not yet "
                                      "implemented in parallel".format(key))
        # must be sorted to be identical on all procs
        return sorted(list(nodeGroups))

    def _hasDirichletLoadings(self, keywords):
        """return True if instance has Dirichlet loadings"""
        for key in list(keywords.keys()):
            if key in self.dirichletLoads:
                return True
        return False

    def _hasNeumannLoadings(self, keywords):
        """return True if instance has Neumann loadings"""
        for key in list(keywords.keys()):
            if key in self.neumannLoads:
                return True
        return False

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        model = keywords["MODELE"]
        if not model.getSupportMesh().isParallel() or self._hasNeumannLoadings(keywords):
            self._result = GenericMechanicalLoad(model)
        if model.getSupportMesh().isParallel():
            if self._hasDirichletLoadings(keywords) and self._hasNeumannLoadings(keywords):
                raise TypeError("Not allowed to mix up Dirichlet and Neumann loadings in the same parallel AFFE_CHAR_MECA")

    def exec_(self, keywords):
        """Override default _exec in case of parallel load
        """
        if isinstance(self._result, GenericMechanicalLoad):
            super(MechanicalLoadDefinition, self).exec_(keywords)
        else:
            from ..Objects import ParallelMechanicalLoad, PartialMesh
            model = keywords.pop("MODELE")
            partialMesh = PartialMesh(model.getSupportMesh(), self._getNodeGroups(keywords))
            if partialMesh.getDimension()==3:
                modelisation = "3D"
            else:
                modelisation = "D_PLAN"
            partialModel = AFFE_MODELE(MAILLAGE=partialMesh,
                                       AFFE=(_F(TOUT='OUI',
                                               PHENOMENE='MECANIQUE',
                                               MODELISATION=modelisation,),
                                             _F(TOUT='OUI',
                                               PHENOMENE='MECANIQUE',
                                               MODELISATION='DIS_T',),
                                               ),
                                       VERI_JACOBIEN='NON',
                                       DISTRIBUTION=_F(METHODE='CENTRALISE',),)
            partialModel.getFiniteElementDescriptor().transferDofDescriptorFrom(model.getFiniteElementDescriptor())
            keywords["MODELE"] = partialModel
            partialMechanicalLoad = AFFE_CHAR_MECA(**keywords)
            keywords["MODELE"] = model
            self._result = ParallelMechanicalLoad(partialMechanicalLoad, model)

AFFE_CHAR_MECA = MechanicalLoadDefinition.run
