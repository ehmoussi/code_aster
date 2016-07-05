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

# person_in_charge: guillaume.drouet@edf.fr

from code_aster import Solvers, LinearAlgebra
from code_aster.Cata import Commands
from code_aster.Cata.SyntaxChecker import checkCommandSyntax
from code_aster.Utilities.CppToFortranGlossary import FortranGlossary


def MODE_STATIQUE( **kwargs ):

    checkCommandSyntax( Commands.MODE_STATIQUE, kwargs )
    glossary  = FortranGlossary()
    results = None
    kw_Smat   = kwargs.get( "MATR_RIGI" )
    kw_Mmat   = kwargs.get( "MATR_MASS" )
    fkw_mstat = kwargs.get( "MODE_STAT" )
    fkw_fnoda = kwargs.get( "FORCE_NODALE" )
    fkw_psdo  = kwargs.get( "PSEUDO_MODE" )
    fkw_interf= kwargs.get( "MODE_INTERF" )
    # Exactly one ("MODE_STAT","FORCE_NODALE", "PSEUDO_MODE", "MODE_INTERF")
    if fkw_mstat != None:
        mode_stat=Solvers.StaticModeDepl()
        mode_stat.setStiffMatrix(kw_Smat)
        if kw_Mmat != None:
            mode_stat.setMassMatrix(kw_Mmat)
        # Exactly one ("TOUT", "GROUP_NO")    
        kwtout = fkw_mstat.get( "TOUT" )
        kwGroupNo = fkw_mstat.get( "GROUP_NO" )
        if kwtout != None:                        
            mode_stat.setAllLoc()
        if kwGroupNo != None:
            mode_stat.WantedGrno(kwGroupNo)
        # Exactly one ("TOUT_CMP", "AVEC_CMP", "SANS CMP") 
        kwtoutcmp = fkw_mstat.get( "TOUT_CMP" )
        kwcmpad   = fkw_mstat.get( "AVEC_CMP" )
        kwcmple   = fkw_mstat.get( "SANS_CMP" )
        if kwtoutcmp != None:
            mode_stat.setAllCmp()
        if kwcmpad != None:
            mode_stat.Wantedcmp(kwcmpad)  
        elif kwcmple != None:
            mode_stat.Unwantedcmp(kwcmple)
        solver=LinearAlgebra.LinearSolver();       
        fkw_solver = kwargs.get( "SOLVEUR" )
        if fkw_solver != None:
            print(NotImplementedError("Not yet implemented: '{0}' is ignored".format("SOLVEUR")))
        mode_stat.setLinearSolver(solver)    
        results = mode_stat.execute()  
        print results    
        return results
    elif fkw_fnoda != None:
        force_noda=Solvers.StaticModeForc()
        force_noda.setStiffMatrix(kw_Smat)
        if kw_Mmat != None:
            force_noda.setMassMatrix(kw_Mmat)
        # Exactly one ("TOUT", "GROUP_NO")     
        kwtout = fkw_fnoda.get( "TOUT" )
        kwGroupNo = fkw_fnoda.get( "GROUP_NO" )
        if kwtout != None:                        
            force_noda.setAllLoc()
        elif kwGroupNo != None:
            force_noda.WantedGrno(kwGroupNo)
        # Exactly one ("TOUT_CMP", "AVEC_CMP", "SANS CMP")
        kwtoutcmp = fkw_fnoda.get( "TOUT_CMP" )
        kwcmpad   = fkw_fnoda.get( "AVEC_CMP" )
        kwcmple   = fkw_fnoda.get( "SANS_CMP" )
        if kwtoutcmp != None:
            force_noda.setAllCmp()
        elif kwcmpad != None:
            force_noda.Wantedcmp(kwcmpad)  
        elif kwcmple != None:
            force_noda.Unwantedcmp(kwcmple)
        solver=LinearAlgebra.LinearSolver();       
        fkw_solver = kwargs.get( "SOLVEUR" )
        if fkw_solver != None:
            print(NotImplementedError("Not yet implemented: '{0}' is ignored".format("SOLVEUR")))
        force_noda.setLinearSolver(solver)            
        return force_noda.execute()
    elif fkw_psdo != None:
        pseudo_mod=Solvers.StaticModePseudo()
        pseudo_mod.setStiffMatrix(kw_Smat)
        pseudo_mod.setMassMatrix(kw_Mmat)
        # Exactly one ("TOUT", "GROUP_NO","DIRECTION","AXE")     
        kwtout = fkw_psdo.get( "TOUT" )
        kwGroupNo = fkw_psdo.get( "GROUP_NO" )
        kwDir     = fkw_psdo.get( "DIRECTION" )
        kwAxe     = fkw_psdo.get( "AXE" )
        if kwtout != None:                        
            pseudo_mod.setAllLoc()
        elif kwGroupNo != None:
            pseudo_mod.WantedGrno(kwGroupNo)
        elif kwDir != None:
            kwdirname = fkw_psdo.get( "NOM_DIR" )
            pseudo_mod.setDirname(kwdirname)
            pseudo_mod.WantedDir(kwDir)
        elif kwAxe != None:
            pseudo_mod.Wanted_axe(kwAxe)
        # Bloc (TOUT=OUI or "GROUP_NO" != None)
        if  kwGroupNo != None or kwtout != None:
        
            kwtoutcmp = fkw_psdo.get( "TOUT_CMP" )
            kwcmpad   = fkw_psdo.get( "AVEC_CMP" )
            kwcmple   = fkw_psdo.get( "SANS_CMP" )
            if kwtoutcmp!=None:
                pseudo_mod.setAllCmp()
            elif kwcmpad != None:
                pseudo_mod.Wantedcmp(kwcmpad)  
            elif kwcmple != None:
                pseudo_mod.Unwantedcmp(kwcmple)
        solver=LinearAlgebra.LinearSolver();       
        fkw_solver = kwargs.get( "SOLVEUR" )
        if fkw_solver != None:
            print(NotImplementedError("Not yet implemented: '{0}' is ignored".format("SOLVEUR")))
        pseudo_mod.setLinearSolver(solver)           
        return pseudo_mod.execute()
        
    elif fkw_interf != None:
        mode_interf=Solvers.StaticModeInterf()
        mode_interf.setStiffMatrix(kw_Smat)
        if kw_Mmat != None:
            mode_interf.setMassMatrix(kw_Mmat)
        # Exactly one ("TOUT", "GROUP_NO")     
        kwtout = fkw_interf.get( "TOUT" )
        kwGroupNo = fkw_interf.get( "GROUP_NO" )
        if kwtout != None:                        
            mode_interf.setAllLoc()
        elif kwGroupNo != None:
            mode_interf.WantedGrno(kwGroupNo)
        # Exactly one ("TOUT_CMP", "AVEC_CMP", "SANS CMP")
        kwtoutcmp = fkw_interf.get( "TOUT_CMP" )
        kwcmpad   = fkw_interf.get( "AVEC_CMP" )
        kwcmple   = v.get( "SANS_CMP" )
        if kwtoutcmp != None:
            mode_interf.setAllCmp()
        elif kwcmpad != None:
            mode_interf.Wantedcmp(kwcmpad)  
        elif kwcmple != None:
            mode_interf.Unwantedcmp(kwcmple)
        kwnbmod = fkw_interf.get("NBMOD")
        mode_interf.setNbmod(kwnbmod)
        kwshift = fkw_interf.get("SHIFT")
        mode_interf.setShift(kwshift)
        solver=LinearAlgebra.LinearSolver();       
        fkw_solver = kwargs.get( "SOLVEUR" )
        if fkw_solver != None:
            print(NotImplementedError("Not yet implemented: '{0}' is ignored".format("SOLVEUR")))
        mode_interf.setLinearSolver(solver)            
        return mode_interf.execute()
    else:
        raise 
    
