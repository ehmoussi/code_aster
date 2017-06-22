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

subroutine jeveut(nomlu, cel, jctab)
! ALLOUE UN OBJET EM MEMOIRE DE FACON PERMANENTE (MARQUE = -1)
!
! IN  NOMLU  : NOM DE L'OBJET A ALLOUER
! IN  CEL    : TYPE D'ACCES 'E' OU 'L'
! OUT JCTAB  : ADRESSE DANS LE COMMUN DE REFERENCE ASSOCIE
! ----------------------------------------------------------------------
    implicit none
#include "asterfort/jeveuo.h"
    integer,intent(out) :: jctab
    character(len=*),intent(in) :: nomlu, cel
!     ------------------------------------------------------------------
    integer :: ipgc, kdesma(2), lgd, lgduti, kposma(2), lgp, lgputi
    common /iadmje/  ipgc,kdesma,   lgd,lgduti,kposma,   lgp,lgputi
! DEB ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: ipgcex
!-----------------------------------------------------------------------
    ipgcex = ipgc
    ipgc = -1
    call jeveuo(nomlu, cel, jctab)
    ipgc = ipgcex
! FIN ------------------------------------------------------------------
end subroutine
