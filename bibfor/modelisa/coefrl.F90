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

subroutine coefrl(nom1, nom2, nom3, nckmax, ipas,&
                  ires, bornck, nborck, coefck, ipas1,&
                  ires1)
    implicit none
!  IN    : NOM1      : A RENSEIGNER
!  IN    : NOM2      : A RENSEIGNER
!  IN    : NOM3      : A RENSEIGNER
!  IN    : NCKMAX    : A RENSEIGNER
!  IN    : IPAS      : A RENSEIGNER
!  IN    : IRES      : A RENSEIGNER
!  OUT   : BORNCK    : A RENSEIGNER
!  OUT   : COEFCK    : A RENSEIGNER
!  OUT   : IPAS1     : A RENSEIGNER
!  OUT   : IRES1     : A RENSEIGNER
!-----------------------------------------------------------------------
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ulisop.h"
#include "asterfort/ulopen.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    integer :: ipas, ires, nckmax, nborck
    real(kind=8) :: bornck(20), coefck(20, 11)
    character(len=24) :: nom1, nom2, nom3
!
!     UN COMMON AJOUTE POUR RESORBER UNE GLUTE ANTIQUE (VOIR HISTOR):
    character(len=8) :: typflu
    common  / kop144 / typflu
!
    integer :: unit, nbomax, nbloc
    integer :: jborne, jcoeff, jvired, nbval1, nbval2, nbval3
    real(kind=8) :: zero, bock1(20), coef1(20, 11)
    real(kind=8) :: vrmin, vrmax
    character(len=16) :: k16nom
    character(len=24) :: nom4
!
! ----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, ipas1, ires1, iunit, j, k, kk
    integer :: nb1
!-----------------------------------------------------------------------
    call jemarq()
!
! --- LECTURE DU FICHIER DE DONNEES
!     =============================
!
    nom4 = typflu//'.UNIT_FAISCEAU'
    call jeveuo(nom4, 'L', iunit)
    unit = zi(iunit-1+2)
    nbomax = 20
    k16nom = ' '
    if (ulisop ( unit, k16nom ) .eq. 0) then
        call ulopen(unit, ' ', ' ', 'NEW', 'O')
    endif
    read (unit,*) nbloc
    zero = 0.0d0
!
! --- BLOC D'INITIALISATION
    do i = 1, nbomax
        bock1 (i) = zero
        bornck(i) = zero
        do 20 j = 1, nckmax
            coef1 (i,j) = zero
            coefck(i,j) = zero
20      continue
    end do
!
    do kk = 1, nbloc
        read (unit,*) ipas1
        read (unit,*) ires1
        read (unit,*) nb1
        if (ipas1 .eq. ipas .and. ires1 .eq. ires) then
            nbval1 = 3
            nbval2 = nb1 + nb1*nckmax
            nbval3 = 2
            call wkvect(nom1, 'V V I', nbval1, jborne)
            call wkvect(nom2, 'V V R', nbval2, jcoeff)
            call wkvect(nom3, 'V V R', nbval3, jvired)
            zi(jborne-1+1) = ipas1
            zi(jborne-1+2) = ires1
            zi(jborne-1+3) = nb1
            read (unit,*) (bock1(i),i = 1,nb1),vrmin,vrmax
            do 40 i = 1, nb1
                zr( jcoeff+i-1 ) = bock1(i)
40          continue
!
            zr(jvired-1+1) = vrmin
            zr(jvired-1+2) = vrmax
!
            k = 1
            do 50 i = 1, nb1
                read (unit,*) (coef1(i,j),j = 1,nckmax)
                do 60 j = 1, nckmax
                    zr(jcoeff+nb1+k-1) = coef1(i,j)
                    k = k + 1
60              continue
50          continue
!
            nborck = nb1
!
            do 70 i = 1, nb1
                bornck(i) = bock1(i)
                do 80 j = 1, nckmax
                    coefck(i,j) = coef1(i,j)
80              continue
70          continue
            goto 120
        else
            read (unit,*) (bock1(i),i = 1,nb1),vrmin,vrmax
            do 90 i = 1, nb1
                read (unit,*) (coef1(i,j),j = 1,nckmax)
90          continue
            read (unit,*)
        endif
    end do
    if (ipas1 .ne. ipas .or. ires1 .ne. ires) then
        call utmess('F', 'MODELISA4_33')
    endif
!
120  continue
    call ulopen(-unit, ' ', ' ', ' ', ' ')
    call jedema()
!
end subroutine
