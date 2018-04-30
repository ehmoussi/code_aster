! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

function iunifi(name)
    implicit none
    integer :: iunifi
#include "asterfort/ulinit.h"
    character(len=*) :: name
!
!     ------------------------------------------------------------------
!     RETOURNE L'UNITE LOGIQUE ATTACHEE AU NOM LOCAL NAME (DDNAME)
!     ------------------------------------------------------------------
!
! IN  NAME   : CH*16 : NOM "LOCALE" DONT ON RECHERCHE LE NUMERO D'UNITE
!                      LOGIQUE ASSOCIEE
! OUT IUNIFI : IS    : NUMERO D'UNITE LOGIQUE ASSOCIE A "NAME"
!                      RENVOI 0 SI LE NOM N'EST PAS DANS LES TABLES
!
!     ------------------------------------------------------------------
!     REMARQUE : SUPPOSE QUE LA DEFINITION DU COUPLE (UNITE LOGIQUE,NOM)
!                EST DEJA FAITE (CF ULDEFI)
!     REMARQUE : SI L'INITIALISATION N'A PAS ETE FAITE LA ROUTINE S'EN
!                CHARGERA (APPEL A ULINIT)
!     ------------------------------------------------------------------
! person_in_charge: j-pierre.lefebvre at edf.fr
!
    integer :: mxf
    parameter       (mxf=100)
    character(len=1) :: typefi(mxf), accefi(mxf), etatfi(mxf), modifi(mxf)
    character(len=16) :: ddname(mxf)
    character(len=255) :: namefi(mxf)
    integer :: first, unitfi(mxf), nbfile
    common/ asgfi1 / first, unitfi      , nbfile
    common/ asgfi2 / namefi,ddname,typefi,accefi,etatfi,modifi
!
    character(len=16) :: name16
    integer :: i
!     ------------------------------------------------------------------
!     CONSERVER LA COHERENCE AVEC IBIMPR
    integer :: mximpr
    parameter   ( mximpr = 3)
    character(len=16) :: nompr (mximpr)
    integer :: unitpr (mximpr)
    data          nompr  /'MESSAGE'  , 'RESULTAT', 'ERREUR'/
    data          unitpr /    6      ,     6     ,      6  /
!     ------------------------------------------------------------------
!
    if (first .ne. 17111990) call ulinit()
!
    name16 = name
    iunifi = 0
!
!     VALEUR PAR DEFAUT POUR LES NOMS INTERNES
    do 10 i = 1, mximpr
        if (name16 .eq. nompr(i)) then
            iunifi = unitpr(i)
            goto 99
        endif
10  end do
!
    do 20 i = 1, nbfile
        if (name16 .eq. ddname(i)) then
            iunifi = unitfi(i)
            goto 99
        endif
20  end do
!
99  continue
end function
