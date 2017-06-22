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

subroutine sdmail(nomu, nommai, nomnoe, cooval, coodsc,&
                  cooref, grpnoe, gpptnn, grpmai, gpptnm,&
                  connex, titre, typmai, adapma)
    implicit none
!
    character(len=8) :: nomu
    character(len=24) :: nommai, nomnoe, cooval, coodsc, cooref, grpnoe
    character(len=24) :: gpptnn, grpmai, gpptnm, connex, titre, typmai, adapma
!
! person_in_charge: nicolas.sellenet at edf.fr
!
#include "jeveux.h"
!
!     CONSTRUCTION DES NOMS JEVEUX POUR L OBJET-MAILLAGE
!
    nommai = nomu//'.NOMMAI         '
    nomnoe = nomu//'.NOMNOE         '
    cooval = nomu//'.COORDO    .VALE'
    coodsc = nomu//'.COORDO    .DESC'
    cooref = nomu//'.COORDO    .REFE'
    grpnoe = nomu//'.GROUPENO       '
    gpptnn = nomu//'.PTRNOMNOE      '
    grpmai = nomu//'.GROUPEMA       '
    gpptnm = nomu//'.PTRNOMMAI      '
    connex = nomu//'.CONNEX         '
    titre = nomu//'           .TITR'
    typmai = nomu//'.TYPMAIL        '
    adapma = nomu//'.ADAPTATION     '
!
end subroutine
