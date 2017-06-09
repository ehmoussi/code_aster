! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine dimsl(ndim, nno, nnos, dimdef, dimcon,&
                 nnom, nnoc, nddls, nddlm, nddlc,&
                 dimuel, regula)
    implicit      none
    integer :: ndim, nno, nnos, dimdef, dimcon, nnom, nnoc, nddls, nddlm
    integer :: nddlc, dimuel, regula(6)
! ======================================================================
! --- BUT : INITIALISATION DES GRANDEURS NECESSAIRES POUR LA GESTION ---
! ---       DU CALCUL AVEC REGULARISATION A PARTIR DU MODELE SECOND ----
! ---       GRADIENT A MICRO-DILATATION --------------------------------
! ======================================================================
    integer :: def1, def2, cont1, cont2
! ======================================================================
    nnoc = 0
    def1 = 1
    def2 = ndim
    dimdef = def1+def2
    cont1 = 1
    cont2 = ndim
    dimcon = cont1+cont2
! ======================================================================
! --- DIMENSION DU VECTEUR DES DEFORMATIONS GENERALISEES ---------------
! ======================================================================
! --- [E] = [DEPV,DGONFDX,DGONFDY,DGONFDZ] ------------------------
! ======================================================================
    nddls = ndim + 1
    nddlm = ndim
    nddlc = 0
! ======================================================================
    nnom = nno - nnos
    dimuel = nnos*nddls + nnom*nddlm
! ======================================================================
! --- POSITIONS DU POINTEUR REGULA : -----------------------------------
! --- (1) : ADRESSE DES DEFORMATIONS DEP*** ----------------------------
! --- (2) : ADRESSE DES DEFORMATIONS DGONFX* ---------------------------
! --- (3) : ADRESSE DES DEFORMATIONS PRES** ----------------------------
! --- (4) : ADRESSE DES CONTRAINTES GENERALISEES PRES** ----------------
! --- (5) : ADRESSE DES CONTRAINTES GENERALISEES SIG*** ----------------
! --- (6) : ADRESSE DES CONTRAINTES GENERALISEES DEP*** ----------------
! ======================================================================
    regula(1)=1
    regula(2)=regula(1)+def1
    regula(3)=regula(2)+def2
    regula(4)=1
    regula(5)=regula(4)+cont1
    regula(6)=regula(5)+cont2
! ======================================================================
end subroutine
