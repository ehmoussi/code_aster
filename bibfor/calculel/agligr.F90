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

subroutine agligr(long, ligrch)
    implicit none
!
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
#include "asterfort/jeagco.h"
#include "asterfort/jedetr.h"
#include "asterfort/jedupo.h"
#include "asterfort/jelira.h"
#include "asterfort/juveca.h"
    integer :: long
    character(len=19) :: ligrch
! --------------------------------------------------------------------
!   AGRANDISSEMENT DU LIGREL DE CHARGE LIGRCH, LONG ETANT SON NOUVEAU-
!   NOMBRE D'ELEMENTS
! --------------------------------------------------------------------
!  LONG         - IN     - I    - : NOUVEAU NOMBRE D'ELEMENTS DU
!               -        -      -   LIGREL DE CHARGE
! --------------------------------------------------------------------
!  LIGRCH       - IN     - K24  - : NOM DU LIGREL DE CHARGE
!               - JXVAR  -      -   ON AGRANDIT EN CONSERVANT LEURS
!               -        -      -   ANCIENNES VALEURS
!               -        -      -   LES COLLECTIONS :
!               -        -      -                     LIGRCH.LIEL
!               -        -      -                     LIGRCH.NEMA
!               -        -      -   ET LE VECTEUR   : LIGRCH.LGNS
! --------------------------------------------------------------------
!
!
! DEB-------------------------------------------------------------------
!
    character(len=1) :: base
    character(len=24) :: ligr1, ligr2
!
!-----------------------------------------------------------------------
    integer ::  lon1, lon2, long1, long2, long3, nmax1
    integer :: nmax2
!-----------------------------------------------------------------------
    ligr1 = ligrch//'.TRA1'
    ligr2 = ligrch//'.TRA2'
!
!
    call jelira(ligrch//'.LIEL', 'CLAS', cval=base)
!
!
! --- COPIE DE LIGRCH.LIEL ET LIGRCH.NEMA SUR LIGR1 ET LIGR2
!
    call jelira(ligrch//'.LIEL', 'LONT', lon1)
    call jelira(ligrch//'.LIEL', 'NMAXOC', nmax1)
    call jedupo(ligrch//'.LIEL', 'V', ligr1, .false._1)
    call jedetr(ligrch//'.LIEL')
!
    call jelira(ligrch//'.NEMA', 'LONT', lon2)
    call jelira(ligrch//'.NEMA', 'NMAXOC', nmax2)
    call jedupo(ligrch//'.NEMA', 'V', ligr2, .false._1)
    call jedetr(ligrch//'.NEMA')
!
! --- COPIE DE LIGR1 ET LIGR2 SUR LIGRCH.LIEL ET LIGRCH.NEMA
!
    long1 = 2*long
    long1 = max(long1,lon1+2*abs((long-nmax1)))
    long2 = 4*long
    long2 = max(long2,lon2+4*abs((long-nmax2)))
!
    long3=max(long,nmax1,nmax2)
    call jeagco(ligr1, ligrch//'.LIEL', long3, long1, base)
    call jeagco(ligr2, ligrch//'.NEMA', long3, long2, base)
!
! --- AGRANDISSEMENT DE LIGRCH.LGNS
!
    call juveca(ligrch//'.LGNS', 2*long3)
!
! --- MENAGE
!
    call jedetr(ligr1)
    call jedetr(ligr2)
!
end subroutine
