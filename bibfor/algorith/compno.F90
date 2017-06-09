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

subroutine compno(mailla, nbgr, nomgr, nbto)
    implicit none
!
!***********************************************************************
!    P. RICHARD     DATE 13/07/90
!-----------------------------------------------------------------------
!  BUT: COMPTAGE DU NOMBRE DE NOEUDS CORRESPONDANTS A UNE LISTE DE
!     GROUPENO
!        NOTA BENE: LES NOEUDS PEUVENT APPARAITRE PLUSIEURS FOIS
!
!-----------------------------------------------------------------------
!
! MAILLA /I/: NOM UTILISATEUR DU MAILLAGE
! NBGR     /I/: NOMBRE DE GROUPES DE NOEUDS
! NOMGR    /I/: NOMS DES GROUPES DE NOEUDS
! NBTO     /O/: NOMBRE DE NOEUDS
!
!
!
!
#include "jeveux.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jenonu.h"
#include "asterfort/jexnom.h"
#include "asterfort/utmess.h"
!
    integer :: nbgr
    character(len=8) :: mailla
    character(len=24) :: valk(2), nomcou, nomgr(nbgr)
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, ier, nb, nbto, num
!-----------------------------------------------------------------------
    if (nbgr .eq. 0) then
        nbto=0
        goto 9999
    endif
!
!-------RECUPERATION DES POINTEURS DE GROU_NO---------------------------
!
    call jeexin(mailla//'.GROUPENO', ier)
    if (ier .eq. 0) then
        valk (1) = mailla
        call utmess('F', 'ALGORITH12_57', sk=valk(1))
    endif
!
!-------COMPTAGE DES NOEUD DEFINIS PAR GROUPES--------------------------
!
    nbto=0
!
    do 10 i = 1, nbgr
        nomcou=nomgr(i)
        call jenonu(jexnom(mailla//'.GROUPENO', nomcou), num)
!
        if (num .eq. 0) then
            valk (1) = mailla
            valk (2) = nomcou
            call utmess('F', 'ALGORITH12_58', nk=2, valk=valk)
        endif
!
        call jelira(jexnom(mailla//'.GROUPENO', nomcou), 'LONUTI', nb)
        nbto=nbto+nb
!
10  end do
!
9999  continue
end subroutine
