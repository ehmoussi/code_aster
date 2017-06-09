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

subroutine xitghm(modint, mecani, press1, ndim, nno,&
                  nnos, nnom, npi, npg, nddls,&
                  nddlm, dimuel, ddld, ddlm, nnop,&
                  nnops, nnopm, ipoids, ivf, idfde, ddlp,&
                  ddlc)
    implicit none
!
#   include "asterfort/elrefe_info.h"
    integer :: mecani(5), press1(7)
    integer :: ndim, nnos, nno, nnom
    integer :: npi, npg, nddls, nddlm, dimuel
    integer :: ipoids, ivf, idfde
    character(len=3) :: modint
!
! DECLARATION POUR XFEM
    integer :: ddld, ddlm, ddlp, ddlc
    integer :: nnop, nnops, nnopm
    character(len=8) :: fami(3), elrese(3)
!
    data    elrese /'SE3','TR6','T10'/
    data    fami   /'BID','XINT','XINT'/
!
! person_in_charge: daniele.colombo at ifpen.fr
! ======================================================================
! --- ADAPTATION AU MODE D'INTEGRATION ---------------------------------
! --- DEFINITION DE L'ELEMENT (NOEUDS, SOMMETS, POINTS DE GAUSS) -------
! ======================================================================
! MODINT    METHODE D'INTEGRATION (CLASSIQUE,LUMPEE(D),REDUITE(R) ?)
! NNO       NB DE NOEUDS DU SOUS ELEMENT
! NNOS      NB DE NOEUDS SOMMETS DU SOUS ELEMENT
! NNOM      NB DE NOEUDS MILIEUX DU SOUS ELEMENT
! NNOP      NB DE NOEUDS DE L'ELEMENT PARENT
! NNOS      NB DE NOEUDS SOMMETS DE L'ELEMENT PARENT
! NNOM      NB DE NOEUDS MILIEUX DE L'ELEMENT PARENT
! NDDLS     NB DE DDL SUR LES SOMMETS
! NDDLM     NB DE DDL SUR LES MILIEUX DE FACE OU D ARETE - QU EN EF
! NPI       NB DE POINTS D'INTEGRATION DE L'ELEMENT
! NPG       NB DE POINTS DE GAUSS     POUR CLASSIQUE(=NPI)
!                 SOMMETS             POUR LUMPEE   (=NPI=NNOS)
!                 POINTS DE GAUSS     POUR REDUITE  (<NPI)
! NDIM      DIMENSION DE L'ESPACE
! IPOIDS    POIDS D'INTEGRATION DU SS-ELEMENT QUADRATIQUE
! IVF       FONCTION DE FORME DU SS-ELEMENT QUADRATIQUE
! IDFDE     DERIVES DES FONCTIONS DE FORME DU SS-ELEMENT QUADRATIQUE
! DDLC      NB DE DDL DE CONTACT
! =====================================================================
! ======================================================================
! --- DONNEES POUR XFEM ------------------------------------------------
! ======================================================================
!     RECUPERATION DES NOEUDS DE L'ELEMENT PARENT QUADRATIQUE
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nnop, nnos=nnops)
!
!     RECUPERATION DES PTS DE GAUSS, DES NOEUDS ET FF DES SS-ELEMENTS
    call elrefe_info(elrefe=elrese(ndim), fami=fami(ndim), nno=nno, nnos=nnos,&
                     npg=npi, jpoids=ipoids, jvf=ivf, jdfde=idfde)
!
! ======================================================================
! --- POUR METHODES CLASSIQUE ET LUMPEE NPG=NPI
! ======================================================================
    npg = npi
    nddls = mecani(1)*ddld + press1(1)*ddlp + ddlc
    nddlm = mecani(1)*ddlm
    nnopm = nnop - nnops
    dimuel = nnops*nddls + nnopm*nddlm
    nnom = nno - nnos
! ======================================================================
! --- POUR METHODE REDUITE NPI = NPG+NNOS ------------------------------
! ======================================================================
    if (modint .eq. 'RED') npg= npi-nnops
end subroutine
