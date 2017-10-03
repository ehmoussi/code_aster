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
! person_in_charge: sylvie.granet at edf.fr
! aslint: disable=W1504
!
subroutine caethm(l_axi, l_steady, l_vf, &
                  type_elem, inte_type, mecani, press1, press2,&
                  tempe, dimdep, dimdef, dimcon, nddl_meca,&
                  nddl_p1, nddl_p2, ndim, nno, nnos,&
                  nnom, nface, npi, npg, nddls,&
                  nddlm, nddlfa, nddlk, dimuel, jv_poids,&
                  jv_func, jv_dfunc, jv_poids2, jv_func2, jv_dfunc2,&
                  npi2, jv_gano)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/thmGetGene.h"
#include "asterfort/thmGetElemInfo.h"
#include "asterfort/thmGetElemRefe.h"
#include "asterfort/thmGetElemIntegration.h"
#include "asterfort/thmGetElemModel.h"
#include "asterfort/thmGetElemDime.h"
!
aster_logical, intent(out) :: l_axi, l_steady, l_vf
integer, intent(out) :: ndim
integer, intent(out) :: mecani(5), press1(7), press2(7), tempe(5)
character(len=3), intent(out) :: inte_type
integer, intent(out) :: dimdep, dimdef, dimcon, dimuel
integer, intent(out) :: nddl_meca, nddl_p1, nddl_p2
integer, intent(out) :: nno, nnos, nnom, nface
integer, intent(out) :: npi, npi2, npg
integer, intent(out) :: nddls, nddlm, nddlfa, nddlk
integer, intent(out) :: jv_poids, jv_poids2
integer, intent(out) :: jv_func, jv_dfunc, jv_func2, jv_dfunc2
integer, intent(out) :: jv_gano
character(len=8), intent(out) :: type_elem(2)
!
! --------------------------------------------------------------------------------------------------
!
! THM - Initializations
!
! Prepare data
!
! --------------------------------------------------------------------------------------------------
!
! IN AXI     : AXI ?
! OUT PERMAN : MODELISATION HM PERMAMENTE ?
! OUT TYPMOD : TYPE DE MODELISATION (AXI DPLAN 3D)
! OUT MODINT : METHODE D'INTEGRATION (CLASSIQUE,LUMPEE(D),REDUITE(R) ?)
! OUT MECANI : TABLEAU INFO SUR MECANIQUE
! OUT PRESS1 : TABLEAU INFO SUR HYDRAULIQUE CONSTITUANT 1
! OUT PRESS2 : TABLEAU INFO SUR HYDRAULIQUE CONSTITUANT 2
! OUT TEMPE  : TABLEAU INFO SUR THERMIQUE
! OUT DIMDEP : DIMENSION DES DEPLACEMENTS GENERALISES
! OUT DIMDEF : DIMENSION DES DEFORMATIONS GENERALISEES
! OUT DIMCON : DIMENSION DES CONTRAINTES GENERALISEES
! OUT NMEC   : NOMBRE DE COMPOSANTES DU VECTEUR DEPLACEMENT
! OUT NP1    : 1 SI IL Y A UNE EQUATION POUR P1, 0 SINON
! OUT NP2    : 1 SI IL Y A UNE EQUATION POUR P2, 0 SINON
! OUT NDIM   : DIMENSION DU PROBLEME (2 OU 3)
! OUT NNO    : NOMBRE DE NOEUDS DE L'ELEMENT
! OUT NNOS   : NOMBRE DE NOEUDS SOMMETS DE L'ELEMENT
! OUT NFACE  : NB FACES AU SENS BORD DE DIMENSION DIM-1 NE SERT QU EN VF
! OUT NNOM   : NB NOEUDS MILIEUX DE FACE OU D ARRETE NE SERT QU EN EF
! OUT NPI    : NOMBRE DE POINTS D'INTEGRATION DE L'ELEMENT
! OUT NPG    : NOMBRE DE POINTS DE GAUSS     POUR CLASSIQUE(=NPI)
!                        SOMMETS             POUR LUMPEE   (=NPI=NNOS)
!                        POINTS DE GAUSS     POUR REDUITE  (<NPI)
! OUT NDDLS  : NOMBRE DE DDL SUR LES SOMMETS
! OUT NDDLM  : NB DDL SUR LES MILIEUX FACE OU D ARRETE NE SERT QU EN EF
! OUT NDDLFA    NB DE DDL SUR LES FACES DE DIM DIM-1 NE SERT QU EN VF
! OUT NDDLK  : NOMBRE DE DDL SUR LA MAILLE (BULL OU VF)
! OUT DIMUEL : NOMBRE DE DDL TOTAL DE L'ELEMENT
! OUT IPOIDS : ADRESSE DU TABLEAU POIDS POUR FONCTION DE FORME P2
! OUT IVF    : ADRESSE DU TABLEAU DES FONCTIONS DE FORME P2
! OUT IDFDE  : ADRESSE DU TABLEAU DES DERIVESS DES FONCTIONS DE FORME P2
! OUT IPOID2 : ADRESSE DU TABLEAU POIDS POUR FONCTION DE FORME P1
! OUT IVF2   : ADRESSE DU TABLEAU DES FONCTIONS DE FORME P1
! OUT IDFDE2 : ADRESSE DU TABLEAU DES DERIVESS DES FONCTIONS DE FORME P1
! OUT JGANO  : ADRESSE DANS ZR DE LA MATRICE DE PASSAGE
!              GAUSS -> NOEUDS
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: elrefe, elref2
!
! --------------------------------------------------------------------------------------------------
!

!
! - Get model of finite element
!
    call thmGetElemModel(l_axi, l_vf, l_steady, ndim, type_elem)
!
! - Get type of integration
!
    call thmGetElemIntegration(l_vf, inte_type)     
!
! - Get generalized coordinates
!
    call thmGetGene(l_steady, l_vf, ndim,&
                    mecani, press1, press2, tempe)
!
! - Get reference elements
!
    call thmGetElemRefe(l_vf, elrefe, elref2)
!
! - Get informations about element
!
    call thmGetElemInfo(l_vf     , elrefe  , elref2   ,&
                        nno      , nnos    , nnom     ,&
                        jv_gano  , jv_poids, jv_poids2,&
                        jv_func  , jv_func2, jv_dfunc , jv_dfunc2,&
                        inte_type, npi     , npi2     , npg)
!
! - For finite volume
!
    if (l_vf) then
        if (ndim .eq. 2) then
            nface = nnos
        else
            if (elrefe .eq. 'H27') then
                nface = 6
            else if (elrefe .eq. 'T9') then
                nface = 4
            else
                ASSERT(ASTER_FALSE)
            endif
        endif
    else
        nface = 0
    endif
!
! - Get dimensions about element
!
    call thmGetElemDime(l_vf     ,&
                        ndim     , nnos   , nnom   ,&
                        mecani   , press1 , press2 , tempe ,&
                        nddls    , nddlm  , &
                        nddl_meca, nddl_p1, nddl_p2,&
                        dimdep   , dimdef , dimcon , dimuel,&
                        nface    , nddlk  , nddlfa )
!
end subroutine
