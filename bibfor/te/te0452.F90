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

subroutine te0452(option, nomte)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/excent.h"
#include "asterfort/jevech.h"
#include "asterfort/tecach.h"
!
    character(len=16) :: option, nomte
!     OPTION : EFGE_ELNO_EXCENT
!     IN   K16   OPTION : NOM DE L'OPTION A CALCULER
!     IN   K16   NOMTE  : NOM DU TYPE_ELEMENT
!     ------------------------------------------------------------------
    integer :: itab1(7), itab2(7), iret, jin, jout, lgcata
    integer :: nbpoin, nbcmp, jcara, ibid
    aster_logical :: lreel
    real(kind=8) :: excen
!     ------------------------------------------------------------------
!
    ASSERT(option.eq.'EFGE_EXCENT')
!
!     -- IL Y A 4 CAS POSSIBLES : GAUSS/NOEUD + REEL/COMPLEXE
    call tecach('ONO', 'PEFFONR', 'L', iret, nval=7,&
                itab=itab1)
    if (iret .eq. 0) then
        lreel=.true.
        call tecach('OOO', 'PEFFOENR', 'E', ibid, nval=7,&
                    itab=itab2)
    else
        call tecach('ONO', 'PEFFONC', 'L', iret, nval=7,&
                    itab=itab1)
        if (iret .eq. 0) then
            lreel=.false.
            call tecach('OOO', 'PEFFOENC', 'E', ibid, nval=7,&
                        itab=itab2)
        else
            call tecach('ONO', 'PEFFOGR', 'L', iret, nval=7,&
                        itab=itab1)
            if (iret .eq. 0) then
                lreel=.true.
                call tecach('OOO', 'PEFFOEGR', 'E', ibid, nval=7,&
                            itab=itab2)
            else
                lreel=.false.
                call tecach('OOO', 'PEFFOGC', 'L', ibid, nval=7,&
                            itab=itab1)
                call tecach('OOO', 'PEFFOEGC', 'E', ibid, nval=7,&
                            itab=itab2)
            endif
        endif
    endif
!
    jin=itab1(1)
    nbpoin=itab1(3)
    lgcata=itab1(2)
    nbcmp=lgcata/nbpoin
    ASSERT(lgcata.eq.nbpoin*nbcmp)
    ASSERT(nbcmp.eq.6.or.nbcmp.eq.8)
!
    jout=itab2(1)
    ASSERT(itab2(2).eq.lgcata)
!
    call jevech('PCACOQU', 'L', jcara)
    excen=zr(jcara+5-1)
!
    call excent('MOY', excen, nbpoin, nbcmp, lreel,&
                zr(jin), zr(jout), zc(jin), zc(jout))
!
!
!
end subroutine
