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

subroutine ini002(nomte, nmax, itabl, k24tab, nval)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elref2.h"
#include "asterfort/jeexin.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jni002.h"
#include "asterfort/jni015.h"
#include "asterfort/jni080.h"
#include "asterfort/jni091.h"
#include "asterfort/jni092.h"
#include "asterfort/nuelrf.h"
!
! person_in_charge: jacques.pellet at edf.fr
!
    character(len=16), intent(in) :: nomte
    integer, intent(in) :: nmax
    integer, optional, intent(out):: itabl(nmax)
    character(len=24), optional, intent(inout) :: k24tab(nmax)
    integer, optional, intent(out):: nval
!-----------------------------------------------------------------------
!
! BUT :  ROUTINE D'INITIALISATION DES ELEMENTS AYANT DES ELREFE
!
! IN  NOMTE : NOM DU TYPE ELEMENT
! IN  NMAX  : DIMENSION DES TABLEAUX ITABL ET K24TAB
! OUT NVAL  : NVAL EST LE NOMBRE D'OBJETS CREES PAR INI0IJ
!              (SI NVAL > NMAX : NVAL = -NVAL ET ITABL EST VIDE)
! OUT K24TAB: CE TABLEAU CONTIENT LES NOMS DES OBJETS
!             QUE L'ON PEUT RECUPERER DANS LES TE000I
!             VIA LA ROUTINE JEVETE.
! OUT ITABL : CE TABLEAU CONTIENT LES ADRESSES
!             DES OBJETS DE K24TAB DANS ZR, ZI, ...
!   -------------------------------------------------------------------
!-----------------------------------------------------------------------

    character(len=8) :: elrefe, lirefe(10)
    integer :: nujni
    character(len=24) :: liobj(10)
    integer :: nbelr, ii, kk, iret, nbobj, k, nb_val
! DEB ------------------------------------------------------------------
!
! --- RECUPERATION DE LA LISTE DES ELREFE CORRESPONDANTS AU NOMTE
    call elref2(nomte, 10, lirefe, nbelr)
    ASSERT(nbelr.ge.0)
!
!
!     --BOUCLE SUR LES ELREFE :
!     -------------------------
    nb_val = 0
    do ii = 1, nbelr
        elrefe = lirefe(ii)
        call nuelrf(elrefe, nujni)
!
!
!       -- CAS DES ELREFA :
!       -------------------
        if (nujni .eq. 2) then
            call jni002(elrefe, 10, liobj, nbobj)
!
        else if (nujni.eq.15) then
            call jni015(elrefe, 10, liobj, nbobj)
!
        else if (nujni.eq.80) then
            call jni080(elrefe, 10, liobj, nbobj)
!
        else if (nujni.eq.91) then
            call jni091(elrefe, 10, liobj, nbobj)
!
        else if (nujni.eq.92) then
            call jni092(elrefe, 10, liobj, nbobj)
!
        else
            ASSERT(.false.)
        endif
!
        nb_val = nb_val + nbobj
        ASSERT(nb_val.le.nmax)
!
        if (present(k24tab)) then
            do k = 1, nbobj
                k24tab(nb_val-nbobj+k) = liobj(k)
            end do
        endif
    end do
!
    if (present(nval)) then
        nval = nb_val
    endif
!
!     RECUPERATION DES ADRESSES DES OBJETS CREES :
!     ---------------------------------------------
    if (present(k24tab)) then
        do kk = 1, nb_val
            call jeexin(k24tab(kk), iret)
            if (iret .gt. 0) then
                call jeveuo(k24tab(kk), 'L', itabl(kk))
            endif
        end do
    endif
!
end subroutine
