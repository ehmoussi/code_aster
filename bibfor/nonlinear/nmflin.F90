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

subroutine nmflin(sdpost, matass, freqr, linsta)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/echmat.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmlesd.h"
#include "asterfort/utmess.h"
    character(len=19) :: sdpost
    character(len=19) :: matass
    aster_logical :: linsta
    real(kind=8) :: freqr
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (POST-TRAITEMENT)
!
! DETECTION D'UNE INSTABILITE
!
! ----------------------------------------------------------------------
!
!
! IN  MATASS : MATRICE ASSEMBLEE
! IN  SDPOST : SD POUR POST-TRAITEMENTS (CRIT_STAB ET MODE_VIBR)
! IN  FREQR  : FREQUENCE SOLUTION INSTABILITE
! OUT LINSTA : .TRUE. SI INSTABILITE DETECTEE
!
!
!
!
    aster_logical :: valtst, ldist
    character(len=24) :: k24bid
    real(kind=8) :: freqr0, prec, r8bid, minmat, maxmat
    character(len=16) :: optrig, sign
    integer :: ibid
    character(len=24), pointer :: refa(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    linsta = .false.
!
! --- PARAMETRES
!
    call nmlesd('POST_TRAITEMENT', sdpost, 'SOLU_FREQ_FLAM', ibid, freqr0,&
                k24bid)
    if (abs(freqr0) .gt. 1.d30) freqr0=freqr
    call nmlesd('POST_TRAITEMENT', sdpost, 'RIGI_GEOM_FLAMB', ibid, r8bid,&
                optrig)
    call nmlesd('POST_TRAITEMENT', sdpost, 'PREC_INSTAB', ibid, prec,&
                k24bid)
    call nmlesd('POST_TRAITEMENT', sdpost, 'SIGN_INSTAB', ibid, r8bid,&
                sign)
!
! --- DETECTION INSTABILITE
!
    if (optrig .eq. 'RIGI_GEOM_NON') then
        call jeveuo(matass//'.REFA', 'L', vk24=refa)
        if (refa(11)(1:11) .ne. 'MPI_COMPLET') then
            call utmess('F', 'MECANONLINE6_13')
        endif
        ldist = .false.
        call echmat(matass, ldist, minmat, maxmat)
        if (((freqr0*freqr).lt.0.d0) .or. (abs(freqr).lt.(prec*minmat))) then
            linsta = .true.
        endif
    else
        valtst = .false.
        if (sign .eq. 'POSITIF') then
            valtst = ((freqr.ge.0.d0).and.(abs(freqr).lt.(1.d0+prec)))
        else if (sign.eq.'NEGATIF') then
            valtst = ((freqr.le.0.d0).and.(abs(freqr).lt.(1.d0+prec)))
        else if (sign.eq.'POSITIF_NEGATIF') then
            valtst = (abs(freqr).lt.(1.d0+prec))
        else
            ASSERT(.false.)
        endif
        if (valtst) linsta = .true.
    endif
!
    call jedema()
end subroutine
