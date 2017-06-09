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

subroutine liscrs(lischa, nbchar, base)
!
!
    implicit      none
#include "asterfort/wkvect.h"
    character(len=19) :: lischa
    integer :: nbchar
    character(len=1) :: base
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! CREATION DE LA SD LISTE_CHARGES
!
! ----------------------------------------------------------------------
!
!
! IN  LISCHA : NOM DE LA SD LISTE_CHARGES
! IN  NBCHAR : NOMBRE DE CHARGEMENTS DANS LA LISTE
! IN  BASE   : BASE POUR CREER LA SD
!
! ----------------------------------------------------------------------
!
    character(len=24) :: nomcha, genrch, typcha, typeap, precha, mocfch
    integer :: jncha, jgenc, jtypc, jtypa, jprec, jmcfc
    character(len=24) :: nomfon, typfon, valfon
    integer :: jnfon, jtfon, jvfon
!
! ----------------------------------------------------------------------
!
    nomcha = lischa(1:19)//'.NCHA'
    genrch = lischa(1:19)//'.GENC'
    mocfch = lischa(1:19)//'.MCFC'
    typcha = lischa(1:19)//'.TYPC'
    typeap = lischa(1:19)//'.TYPA'
    precha = lischa(1:19)//'.PREO'
    nomfon = lischa(1:19)//'.NFON'
    typfon = lischa(1:19)//'.TFON'
    valfon = lischa(1:19)//'.VFON'
!
    call wkvect(nomcha, base//' V K8', nbchar, jncha)
    call wkvect(genrch, base//' V I', nbchar, jgenc)
    call wkvect(mocfch, base//' V I', 2*nbchar, jmcfc)
    call wkvect(typcha, base//' V K8', nbchar, jtypc)
    call wkvect(typeap, base//' V K16', nbchar, jtypa)
    call wkvect(precha, base//' V K24', nbchar, jprec)
    call wkvect(nomfon, base//' V K8', nbchar, jnfon)
    call wkvect(typfon, base//' V K16', nbchar, jtfon)
    call wkvect(valfon, base//' V R', 2*nbchar, jvfon)
!
end subroutine
