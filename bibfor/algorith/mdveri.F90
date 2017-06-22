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

subroutine mdveri()
    implicit none
!
!     VERIFICATION DE PREMIER NIVEAU
!
!
!
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    integer :: i, ibid, jref1
    character(len=8) :: nomres, method, amogen, channo
    character(len=8) :: matr1, matr2, basemo
    character(len=24) :: ref1, ref2
    character(len=16) :: typres, nomcmd
!
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: kf, n1, nagen, nared, nbexc, nm
    character(len=24), pointer :: vref2(:) => null()
!-----------------------------------------------------------------------
    call getres(nomres, typres, nomcmd)
    call getvtx('SCHEMA_TEMPS', 'SCHEMA', iocc=1, scal=method, nbret=n1)
!
    call getvid(' ', 'MATR_AMOR', scal=amogen, nbret=nagen)
    call getvr8('AMOR_MODAL', 'AMOR_REDUIT', iocc=1, nbval=0, nbret=nared)

!     IF (NAGEN.EQ.0 .AND. NARED.EQ.0 .AND. METHOD(1:4).EQ.'ITMI') THEN
!        CALL UTMESS('E','ALGORITH5_68')
!     ENDIF
!
!
    call getfac('EXCIT', nbexc)
    kf = 0
    do i = 1, nbexc
        call getvid('EXCIT', 'VECT_ASSE_GENE', iocc=i, nbval=0, nbret=nm)
        if (nm .ne. 0) then
            kf = kf+1
        endif
    end do
!
!     COHERENCE MATRICES
    call getvid(' ', 'MATR_MASS', scal=matr1, nbret=ibid)
    call getvid(' ', 'MATR_RIGI', scal=matr2, nbret=ibid)
    call jeveuo(matr1//'           .REFA', 'L', jref1)
    call jeveuo(matr2//'           .REFA', 'L', vk24=vref2)
    ref1=zk24(jref1)
    ref2=vref2(1)
    if (ref1(1:8) .ne. ref2(1:8)) then
        call utmess('E', 'ALGORITH5_42')
    endif
!
!     COHERENCE SOUS LE MC EXCIT/VECT_ASSE_GENE ET LES MATRICES
    basemo=ref1(1:8)
    do i = 1, nbexc
        call getvid('EXCIT', 'VECT_ASSE_GENE', iocc=i, nbval=ibid, vect=channo,&
                    nbret=nm)
        if (nm .ne. 0) then
            call jeveuo(channo//'           .REFE', 'L', jref1)
            ref1=zk24(jref1)
            if (ref1(1:8) .ne. basemo) then
                call utmess('E', 'ALGORITH5_42')
            endif
        endif
    end do
!
!
!
end subroutine
