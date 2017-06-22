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

subroutine xcaehm(nomte, axi, perman, typmod, modint,&
                  mecani, press1, press2, tempe, dimdef,&
                  dimcon, nmec, np1, np2, ndim,&
                  nno, nnos, nnom, npi, npg,&
                  nddls, nddlm, dimuel, ipoids, ivf,&
                  idfde, ddld, ddlm, ddlp, enrmec, nenr,&
                  dimenr, nnop, nnops, nnopm, enrhyd, ddlc, nfh)
! ======================================================================
! ======================================================================
! person_in_charge: daniele.colombo at ifpen.fr
! --- BUT : PREPARATION DU CALCUL SUR UN ELEMENT THM -------------------
! ======================================================================
!
! IN NOMTE   : NOM DU TYPE D'ELEMENT
! IN AXI     : AXI ?
! IN NFH     : NOMBRE DE DDL HEAVISIDE PAR NOEUD
! OUT PERMAN : MODELISATION HM PERMAMENTE ?
! OUT TYPMOD : TYPE DE MODELISATION (AXI DPLAN 3D)
! OUT MODINT : METHODE D'INTEGRATION (CLASSIQUE,LUMPEE(D),REDUITE(R) ?)
! OUT MECANI : TABLEAU INFO SUR MECANIQUE
! OUT PRESS1 : TABLEAU INFO SUR HYDRAULIQUE CONSTITUANT 1
! OUT PRESS2 : TABLEAU INFO SUR HYDRAULIQUE CONSTITUANT 2
! OUT TEMPE  : TABLEAU INFO SUR THERMIQUE
! OUT DIMDEF : DIMENSION DES DEFORMATIONS GENERALISEES
! OUT DIMCON : DIMENSION DES CONTRAINTES GENERALISEES
! OUT NMEC   : NOMBRE DE COMPOSANTES DU VECTEUR DEPLACEMENT
! OUT NP1    : 1 SI IL Y A UNE EQUATION POUR P1, 0 SINON
! OUT NP2    : 1 SI IL Y A UNE EQUATION POUR P2, 0 SINON
! OUT NDIM   : DIMENSION DU PROBLEME (2 OU 3)
! OUT NNO    : NOMBRE DE NOEUDS DE L'ELEMENT
! OUT NNOS   : NOMBRE DE NOEUDS SOMMETS DE L'ELEMENT
! OUT NNOM   : NB NOEUDS MILIEUX DE FACE OU D ARRETE NE SERT QU EN EF
! OUT NPI    : NOMBRE DE POINTS D'INTEGRATION DE L'ELEMENT
! OUT NPG    : NOMBRE DE POINTS DE GAUSS     POUR CLASSIQUE(=NPI)
!                        SOMMETS             POUR LUMPEE   (=NPI=NNOS)
!                        POINTS DE GAUSS     POUR REDUITE  (<NPI)
! OUT NDDLS  : NOMBRE DE DDL SUR LES SOMMETS
! OUT NDDLM  : NB DDL SUR LES MILIEUX FACE OU D ARRETE NE SERT QU EN EF
! OUT DIMUEL : NOMBRE DE DDL TOTAL DE L'ELEMENT
! OUT IPOIDS : ADRESSE DU TABLEAU POIDS POUR FONCTION DE FORME P2
! OUT IVF    : ADRESSE DU TABLEAU DES FONCTIONS DE FORME P2
! OUT IDFDE  : ADRESSE DU TABLEAU DES DERIVESS DES FONCTIONS DE FORME P2
! OUT DDLC   : NOMBRE DE DDLS DE CONTACT
! CORPS DU PROGRAMME
    implicit none
!
! DECLARATION PARAMETRES D'APPELS
#include "asterf_types.h"
#include "asterfort/modthm.h"
#include "asterfort/typthm.h"
#include "asterfort/xgrdhm.h"
#include "asterfort/xitghm.h"
    aster_logical :: axi, perman, vf
    integer :: typvf, nfh
    integer :: mecani(5), press1(7), press2(7), tempe(5), dimuel
    integer :: ndim, nno, nnos, nnom
    integer :: dimdef, dimcon, nmec, np1, np2
    integer :: npg, npi, nddls, nddlm, ipoids, ivf, idfde
    character(len=3) :: modint
    character(len=8) :: typmod(2)
    character(len=16) :: nomte
!
! DECLARATION POUR XFEM
    integer :: ddld, ddlm, ddlp, dimenr, ddlc
    integer :: enrmec(3), enrhyd(3), nenr
    integer :: nnop, nnops, nnopm
!
! --- INITIALISATIONS --------------------------------------------------
! ======================================================================
    typmod(2) = '        '
! ======================================================================
! --- TYPE DE MODELISATION? AXI/DPLAN/3D ET HM TRANSI/PERM -------------
! ======================================================================
    call typthm(axi, perman, vf, typvf, typmod,&
                ndim)
! ======================================================================
! --- SELECTION DU TYPE D'INTEGRATION ----------------------------------
! ======================================================================
    if (.not.vf) then
        call modthm(modint)
    else
        modint = 'CLA'
    endif
! ======================================================================
! --- INITIALISATION DES GRANDEURS GENERALISEES SELON MODELISATION -----
! ======================================================================
    call xgrdhm(nomte, ndim, mecani, press1, press2,&
                tempe, enrmec, dimdef, dimcon, nmec,&
                np1, np2, nenr, dimenr, enrhyd, nfh)
! ======================================================================
! --- ADAPTATION AU MODE D'INTEGRATION ---------------------------------
! --- DEFINITION DE L'ELEMENT (NOEUDS, SOMMETS, POINTS DE GAUSS) -------
! ======================================================================
    call xitghm(modint, mecani, press1, ndim, nno,&
                nnos, nnom, npi, npg, nddls,&
                nddlm, dimuel, ddld, ddlm, nnop,&
                nnops, nnopm, ipoids, ivf, idfde, ddlp,&
                ddlc)
! ======================================================================
end subroutine
